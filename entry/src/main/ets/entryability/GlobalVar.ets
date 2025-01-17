export class GlobalVar {
  private static instance: GlobalVar;
  private username: string = "";

  private constructor() {}

  public static getInstance(): GlobalVar {
    if (!GlobalVar.instance) {
      GlobalVar.instance = new GlobalVar();
    }
    return GlobalVar.instance;
  }

  public setUsername(username: string): void {
    this.username = username;
  }

  public getUsername(): string {
    return this.username;
  }
}