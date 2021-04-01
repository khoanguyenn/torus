import express from "express";

class App {
	public app: express.Application;
	private port: string | number = process.env.PORT || 3000;

	constructor() {
		this.app = express();

		this.initializeControllers();
	}

	public listen(): void {
		this.app.listen(this.port, () => {
			console.log(`Server is listening on ${this.port}`);
		});
	}

	private initializeControllers() {
		this.app.use("/", (req, res) => {
			res.status(200).send("Hello World");
		});
	}
}

export default App;