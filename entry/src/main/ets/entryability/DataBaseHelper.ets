import { relationalStore } from '@kit.ArkData';
import { NewsItem } from './EntryAbility';
import { bundleManager, Context, UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import { http } from '@kit.NetworkKit';
import { data } from '@kit.TelephonyKit';
import { DateData } from '@kit.ArkUI';

export default class DataBaseHelper {
    rdbStore: relationalStore.RdbStore | undefined = undefined;
    ctx: Context | undefined = undefined;
    ipAddress: string = "";

    constructor(ctx: Context) {
        this.ctx = ctx;
    }

    async createDataBase(): Promise<void> {
        console.log("Entered createDataBase")
        return new Promise((resolve, reject) => {
            const STORE_CONFIG: relationalStore.StoreConfig = {
                name: 'RdbNEWS.db',
                securityLevel: relationalStore.SecurityLevel.S3,
                encrypt: false,
                isReadOnly: false
            };

            // 表结构：NEWS (ID, AUTHOR, CONTENT, DATE, TITLE, TYPE, URL)
            const SQL_CREATE_TABLE =
                'CREATE TABLE IF NOT EXISTS NEWS (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUTHOR TEXT, CONTENT TEXT, DATE TEXT, TITLE TEXT NOT NULL, TYPE TEXT NOT NULL, URL TEXT NOT NULL)';

            const SQL_CREATE_TABLE_HISTORY =
                'CREATE TABLE IF NOT EXISTS HISTORY (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUTHOR TEXT, CONTENT TEXT, DATE TEXT, TITLE TEXT NOT NULL, TYPE TEXT NOT NULL, URL TEXT NOT NULL)'

            const SQL_CREATE_TABLE_LIKES =
                'CREATE TABLE IF NOT EXISTS LIKES (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUTHOR TEXT, CONTENT TEXT, DATE TEXT, TITLE TEXT NOT NULL, TYPE TEXT NOT NULL, URL TEXT NOT NULL)'

            const SQL_CREATE_TABLE_STARRED =
                'CREATE TABLE IF NOT EXISTS STARRED (ID INTEGER PRIMARY KEY AUTOINCREMENT, AUTHOR TEXT, CONTENT TEXT, DATE TEXT, TITLE TEXT NOT NULL, TYPE TEXT NOT NULL, URL TEXT NOT NULL)'

            relationalStore.getRdbStore(this.ctx, STORE_CONFIG, (err, store) => {
                if (err) {
                    console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
                    reject(new Error(`Failed to get RdbStore. Code: ${err.code}, message: ${err.message}`));
                    return;
                }
                console.info('Succeeded in getting RdbStore.');

                this.rdbStore = store;

                // 当数据库创建时，数据库默认版本为0
                if (store.version === 0) {
                    store.executeSql(SQL_CREATE_TABLE, [], (execErr) => {
                        if (execErr) {
                            console.error(`Failed to create table. Code:${execErr.code}, message:${execErr.message}`);
                            reject(new Error(`Failed to create table. Code: ${execErr.code}, message: ${execErr.message}`));
                        }
                    });
                    store.executeSql(SQL_CREATE_TABLE_HISTORY, [], (execErr) => {
                        if (execErr) {
                            console.error(`Failed to create table. Code:${execErr.code}, message:${execErr.message}`);
                            reject(new Error(`Failed to create table. Code: ${execErr.code}, message: ${execErr.message}`));
                        }
                    });
                    store.executeSql(SQL_CREATE_TABLE_LIKES, [], (execErr) => {
                        if (execErr) {
                            console.error(`Failed to create table. Code:${execErr.code}, message:${execErr.message}`);
                            reject(new Error(`Failed to create table. Code: ${execErr.code}, message: ${execErr.message}`));
                        }
                    });
                    store.executeSql(SQL_CREATE_TABLE_STARRED, [], (execErr) => {
                        if (execErr) {
                            console.error(`Failed to create table. Code:${execErr.code}, message:${execErr.message}`);
                            reject(new Error(`Failed to create table. Code: ${execErr.code}, message: ${execErr.message}`));
                        }
                    });
                    store.version = 1;
                    console.info('Table created successfully and version set to 1.');
                    resolve();
                } else {
                    console.info('Database already initialized with version:', store.version);
                    resolve();
                }
            });
        });
    }

    async getNews() :Promise<void>{
        return new Promise((resolve, reject) =>{
            console.log("Entered getNews");
            let httpRequest = http.createHttp();
            httpRequest.on('headersReceive', (header) => {
                console.info('header: ' + JSON.stringify(header));
            });

            bundleManager.getProfileByAbility("entry", "EntryAbility", "ip_config").then((res) =>{
                interface IPConfig {
                    backend_ip_address: string;
                }
                try{
                    let ipConfig:IPConfig = JSON.parse(res.toString())
                    this.ipAddress = ipConfig.backend_ip_address;
                }catch (err){
                    reject("IP Config Error: "+err)
                }
                console.log("Now getting news from http://"+this.ipAddress+"/get_news")
                httpRequest.request("http://"+this.ipAddress+"/get_news", {
                    method: http.RequestMethod.GET,
                    connectTimeout: 3000
                },
                    (err: BusinessError, data: http.HttpResponse) => {
                        if (!err) {
                            //开始写入新闻数据至数据库
                            if (this.rdbStore !== undefined) {
                                console.log("Succeeded in getting RdbStore, start to write in new news")
                            } else {
                                console.log("Failed to get RdbStore")
                            }

                            try {
                                const newsJSONString: string = data.result.toString().replaceAll('\\', '');
                                const newsData: NewsItem[] = JSON.parse(newsJSONString) as NewsItem[];
                                for (let news of newsData) {
                                    const valueBucket: relationalStore.ValuesBucket = {
                                        AUTHOR: news.author,
                                        CONTENT: news.content,
                                        DATE: news.date,
                                        TITLE: news.title,
                                        TYPE: news.type,
                                        URL: news.url
                                    };
                                    //如果title已经相同，则不再插入
                                    let predicates = new relationalStore.RdbPredicates('NEWS');
                                    predicates.equalTo('TITLE', news.title);
                                    (this.rdbStore as relationalStore.RdbStore).query(predicates,
                                        ['ID', 'AUTHOR', 'CONTENT', 'DATE', 'TITLE', 'TYPE', 'URL'],
                                        (err: BusinessError, resultSet) => {
                                            if (err) {
                                                console.error(`Failed to query data. Code:${err.code}, message:${err.message}`);
                                                //假设最坏的情况：有这个新闻
                                            } else if (resultSet.rowCount == 0) { //没有才插入
                                                (this.rdbStore as relationalStore.RdbStore).insert('NEWS', valueBucket,
                                                    (err: BusinessError, rowId: number) => {
                                                        if (err) {
                                                            resultSet.close();
                                                            reject(`Failed to insert data. Code:${err.code}, message:${err.message}`)
                                                        }
                                                        console.info(`Succeeded in inserting data. rowId:${rowId}`);
                                                    })
                                            }
                                            resultSet.close();
                                        })
                                }
                            } catch (error) {
                                httpRequest.off('headersReceive');
                                httpRequest.destroy();
                                reject('Failed to parse JSON:'+ error)
                            }
                            httpRequest.off('headersReceive');
                            httpRequest.destroy();
                            resolve();
                        } else {
                            httpRequest.off('headersReceive');
                            httpRequest.destroy();
                            reject('HTTP error:' + JSON.stringify(err))
                        }
                    });
            })
        })
    }

    async getNewsFromDB(type: string): Promise<NewsItem[]> {
        console.log("Entered getNewsFromDB")
        return new Promise((resolve, reject) => {
            let predicates = new relationalStore.RdbPredicates('NEWS');
            predicates.equalTo('TYPE', type);
            if (this.rdbStore !== undefined) {
                (this.rdbStore as relationalStore.RdbStore).query(predicates,
                    ['ID', 'AUTHOR', 'CONTENT', 'DATE', 'TITLE', 'TYPE', 'URL'], (err: BusinessError, resultSet) => {
                        if (err) {
                            reject(`Failed to query data. Code:${err.code}, message:${err.message}`)
                        }
                        console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);

                        let newsData: NewsItem[] = [];
                        while (resultSet.goToNextRow()) {
                            const author = resultSet.getString(resultSet.getColumnIndex('AUTHOR'));
                            const content = resultSet.getString(resultSet.getColumnIndex('CONTENT'));
                            const date = resultSet.getString(resultSet.getColumnIndex('DATE'));
                            const title = resultSet.getString(resultSet.getColumnIndex('TITLE'));
                            const type = resultSet.getString(resultSet.getColumnIndex('TYPE'));
                            const url = resultSet.getString(resultSet.getColumnIndex('URL'));
                            let newsItem: NewsItem = {
                                author,
                                content,
                                date,
                                title,
                                type,
                                url
                            };
                            newsData.push(newsItem);
                        }
                        // 释放数据集的内存
                        resultSet.close();
                        console.log(`News Data on Type ${type}: ${newsData}`);
                        resolve(newsData.reverse());
                    })
            } else {
                reject(new Error("Failed to get news from DataBase, RDB Not Loaded!!"));
            }
        })
    }

    async getCollectionFromDB(database: string): Promise<NewsItem[]>{
        console.log("Entering getCollectionFromDB, now getting collection: ", database)
        return new Promise((resolve, reject)=>{
            let predicates = new relationalStore.RdbPredicates(database);
            predicates.isNotNull("TITLE"); // 取出所有非空的
            if (this.rdbStore !== undefined) {
                (this.rdbStore as relationalStore.RdbStore).query(predicates,
                    ['ID', 'AUTHOR', 'CONTENT', 'DATE', 'TITLE', 'TYPE', 'URL'], (err: BusinessError, resultSet) => {
                        if (err) {
                            reject(`Failed to query data. Code:${err.code}, message:${err.message}`)
                        }
                        console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}, row count: ${resultSet.rowCount}`);

                        let newsData: NewsItem[] = [];
                        while (resultSet.goToNextRow()) {
                            const author = resultSet.getString(resultSet.getColumnIndex('AUTHOR'));
                            const content = resultSet.getString(resultSet.getColumnIndex('CONTENT'));
                            const date = resultSet.getString(resultSet.getColumnIndex('DATE'));
                            const title = resultSet.getString(resultSet.getColumnIndex('TITLE'));
                            const type = resultSet.getString(resultSet.getColumnIndex('TYPE'));
                            const url = resultSet.getString(resultSet.getColumnIndex('URL'));
                            let newsItem: NewsItem = {
                                author,
                                content,
                                date,
                                title,
                                type,
                                url
                            };
                            newsData.push(newsItem);
                        }
                        // 释放数据集的内存
                        resultSet.close();
                        console.log(`Return newsData in getCollectionFromDB from DB "${database}": ${newsData}`)
                        resolve(newsData.reverse());
                    })
            } else {
                reject(new Error("Failed to get news from DataBase, RDB Not Loaded!!"));
            }
        })
    }

    // 当数据库中含有该项时返回 true，否则返回 false
    async getCollectionFromDBByName(database: string, name: string): Promise<boolean>{
        console.log("Entering getCollectionFromDBByName, now getting collection: ", database, ", name: ", name)
        return new Promise((resolve, reject)=>{
            let predicates = new relationalStore.RdbPredicates(database);
            predicates.equalTo('TITLE', name); //取出标题相同的
            if (this.rdbStore !== undefined) {
                (this.rdbStore as relationalStore.RdbStore).query(predicates,
                    ['ID', 'AUTHOR', 'CONTENT', 'DATE', 'TITLE', 'TYPE', 'URL'], (err: BusinessError, resultSet) => {
                        if (err) {
                            reject(`Failed to query data. Code:${err.code}, message:${err.message}`)
                        }
                        console.info(`ResultSet column names: ${resultSet.columnNames}, column count: ${resultSet.columnCount}`);

                        if(resultSet.rowCount>0){
                            resultSet.close();
                            resolve(true);
                        }else{
                            resultSet.close();
                            resolve(false);
                        }
                    })
            } else {
                reject(new Error("Failed to get news from DataBase, RDB Not Loaded!!"));
            }
        })
    }

    async addToCollection(database: string, news: NewsItem): Promise<void>{
        console.log("Entering addToCollection, now getting collection: ", database, ", writing: ", news.title)
        return new Promise((resolve, reject)=>{
            if (this.rdbStore !== undefined) {
                this.getCollectionFromDBByName(database, news.title).then((res)=>{
                    if(res != true){
                        let valueBucket: relationalStore.ValuesBucket
                        if(database === 'HISTORY'){//如果是历史记录，那么修改为访问时间
                            let nowDate = Date.now();
                            let readableDate = new Date(nowDate).toLocaleString('zh-CN');
                            valueBucket = {
                                AUTHOR: news.author,
                                CONTENT: news.content,
                                DATE: readableDate,
                                TITLE: news.title,
                                TYPE: news.type,
                                URL: news.url
                            };
                        }else{
                            valueBucket = {
                                AUTHOR: news.author,
                                CONTENT: news.content,
                                DATE: news.date,
                                TITLE: news.title,
                                TYPE: news.type,
                                URL: news.url
                            };
                        }
                        (this.rdbStore as relationalStore.RdbStore).insert(database, valueBucket,
                            (err: BusinessError, rowId: number) => {
                                if (err) {
                                    reject(new Error(`Failed to insert data. Code:${err.code}, message:${err.message}`))
                                }
                                console.info(`Succeeded in inserting data. rowId:${rowId}`);
                            })
                    }
                    resolve();
                })
            } else {
                reject(new Error("Failed to get news from DataBase, RDB Not Loaded!!"));
            }
        })
    }

    async deleteFromCollection(database: string, news: NewsItem): Promise<void>{
        console.log("Entering deleteFromCollection, now getting collection: ", database, ", deleting: ", news.title)
        return new Promise((resolve, reject)=>{
            let predicates = new relationalStore.RdbPredicates(database);
            predicates.equalTo('TITLE', news.title); //取出标题相同的
            if (this.rdbStore !== undefined) {
                (this.rdbStore as relationalStore.RdbStore).delete(predicates, (err: BusinessError,  rows: number) => {
                        if (err) {
                            reject(`Failed to query data. Code:${err.code}, message:${err.message}`)
                        }
                        console.log(`Deleted 1 line at row ${rows}.`)
                        resolve();
                    })
            } else {
                reject(new Error("Failed to get news from DataBase, RDB Not Loaded!!"));
            }
        })
    }
}