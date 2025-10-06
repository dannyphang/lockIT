import { Router } from "express";
import express from "express";
const router = Router();
import * as taskImp from "../implementation/task.js";
import * as userImp from "../implementation/user.js";
import * as API from "../shared/service.js";
import * as func from "../shared/function.js";

router.use(express.json());

const logModule = "task";

router.get("/allTask", async (req, res) => {
    try {
        const user = await userImp.verifyUser(func.body(req).headers.authorization);
        taskImp
            .getAllTask(user)
            .then((list) => {
                res.status(200).json(
                    func.responseModel({
                        data: list,
                    })
                );
            })
            .catch((error) => {
                API.createLog(error, req, res, 500, logModule);
                res.status(500).json(
                    func.responseModel({
                        isSuccess: false,
                        responseMessage: error,
                    })
                );
            });
    } catch (error) {
        console.log("Error getting user:", error);
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(
            func.responseModel({
                isSuccess: false,
                responseMessage: error,
            })
        );
    }
});

router.post("/complete", async (req, res) => {
    try {
        const user = await userImp.verifyUser(func.body(req).data.token);
        const task = func.body(req).data.task;
        taskImp
            .completedTask(user, task)
            .then((list) => {
                res.status(200).json(
                    func.responseModel({
                        data: list,
                    })
                );
            })
            .catch((error) => {
                API.createLog(error, req, res, 500, logModule);
                console.log("Error completing task:", error);
                res.status(500).json(
                    func.responseModel({
                        isSuccess: false,
                        responseMessage: error,
                    })
                );
            });
    } catch (error) {
        console.log("Error getting user:", error);
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(
            func.responseModel({
                isSuccess: false,
                responseMessage: error,
            })
        );
    }
});

router.post("/selectTask", async (req, res) => {
    try {
        const user = await userImp.verifyUser(func.body(req).data.token);
        const taskUid = func.body(req).data.taskUid;
        taskImp
            .selectTask(user, taskUid)
            .then((list) => {
                res.status(200).json(
                    func.responseModel({
                        data: list,
                    })
                );
            })
            .catch((error) => {
                API.createLog(error, req, res, 500, logModule);
                res.status(500).json(
                    func.responseModel({
                        isSuccess: false,
                        responseMessage: error,
                    })
                );
            });
    } catch (error) {
        console.log("Error getting user:", error);
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(
            func.responseModel({
                isSuccess: false,
                responseMessage: error,
            })
        );
    }
});

export default router;
