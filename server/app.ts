import express from 'express';

class App {
    public app: express.Application;
    private port: string | number = process.env.PORT || 3000;

    constructor() {
        this.app = express();

        this.initializeControllers();
    }

    public listen() {
        this.app.listen(this.port, () => {
            console.log(`Server is listening on ${this.port}`);
        });
    }

    public getServer() {
        return this.app;
    }

    private initializeControllers() {
        this.app.use('/', (req, res) => {
            res.send('Hello World');
        });
    }
}

export default App;