import "dotenv/config";
import express, { Request, Response, NextFunction } from "express";
import notesRoutes from "./routes/note";
import morgan from "morgan";
import createHttpError, { isHttpError } from "http-errors";


const app = express();

app.use(morgan("dev"));
app.use(express.json());

app.use("/api/notes", notesRoutes);

app.use((req, res, next) => {
    next(createHttpError(404,"Endpoint not found!"));
})

// eslint-disable-next-line @typescript-eslint/no-unused-vars
app.use((error: unknown, req: Request,  res: Response, next: NextFunction)=>{
    console.log(error);
    let errorMessage= "Unknown error!";
    let errorStatus= 500;
    if (isHttpError(error)){
        errorMessage = error.message;
        errorStatus = error.status;
    } 
    res.status(errorStatus).json({"status":errorStatus,"error": errorMessage});
});
   

export default app;
