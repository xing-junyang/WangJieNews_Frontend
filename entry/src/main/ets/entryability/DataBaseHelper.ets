import { relationalStore } from '@kit.ArkData';
import { NewsItem } from './EntryAbility';
import { bundleManager, Context, UIAbility } from '@kit.AbilityKit';
import { BusinessError } from '@ohos.base';
import { http } from '@kit.NetworkKit';
import { data } from '@kit.TelephonyKit';

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
                        } else {
                            store.version = 1;
                            console.info('Table created successfully and version set to 1.');
                            resolve();
                        }
                    });
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
                    method: http.RequestMethod.GET
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
            const STORE_CONFIG: relationalStore.StoreConfig = {
                name: 'RdbNEWS.db',
                securityLevel: relationalStore.SecurityLevel.S3,
                encrypt: false,
                isReadOnly: false
            };
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

    async getCollectionFromDB(database: string){
        console.log("Entering getCollectionFromDB, now getting collection: ", database)
    }

    async getCollectionFromDBByName(database: string, name: string){
        console.log("Entering getCollectionFromDBByName, now getting collection: ", database, ", name: ", name)
    }

    async addToCollection(database: string, news: NewsItem){
        console.log("Entering getCollectionFromDB, now getting collection: ", database, ", writing: ", news.title)
    }

    async deleteFromCollection(database: string, news: NewsItem){
        console.log("Entering deleteFromCollection, now getting collection: ", database, ", deleting: ", news.title)
    }
}