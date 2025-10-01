import { Router } from "express";
import express from "express";
const router = Router();
import * as userImp from "../implementation/user.js";
import * as API from "../shared/service.js";
import * as func from "../shared/function.js";
import multer from "multer";
import path from "path";

router.use(express.json());

const logModule = "user";

// Configure storage
const storage = multer.diskStorage({
    // destination: (req, file, cb) => {
    //     cb(null, "uploads/avatars"); // folder where you want to save
    // },
    filename: (req, file, cb) => {
        // Example: userId + timestamp + extension
        const ext = path.extname(file.originalname);
        cb(null, `${Date.now()}${ext}`);
    },
});

// Create upload instance
const upload = multer({ storage });

router.get("/:uid", async (req, res) => {
    try {
        const uid = req.params.uid;
        userImp
            .getUser(uid)
            .then((list) => {
                res.status(200).json(list);
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

// POST /auth/register
router.post("/register", async (req, res) => {
    try {
        const userData = func.body(req).data;

        userImp
            .register(userData)
            .then((token) => {
                res.status(200).json(
                    func.responseModel({
                        isSuccess: true,
                        responseMessage: "Register success",
                        data: token,
                    })
                );
            })
            .catch((error) => {
                API.createLog(error, req, res, 500, logModule);
                res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
            });
    } catch (error) {
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
    }
});

// POST /auth/login
router.post("/login", async (req, res) => {
    try {
        const userData = func.body(req).data;
        console.log(userData);
        if (!userData.email || !userData.password) {
            return res.status(400).json(func.responseModel({ isSuccess: false, responseMessage: "Missing credentials" }));
        }

        userImp
            .login(userData.email, userData.password)
            .then((token) => {
                res.status(200).json(
                    func.responseModel({
                        data: token,
                        isSuccess: true,
                        responseMessage: "Login success",
                    })
                );
            })
            .catch((error) => {
                return res.status(401).json(func.responseModel({ isSuccess: false, responseMessage: "Invalid credentials" }));
            });
    } catch (error) {
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
    }
});

// get points transaction history by user id
router.get("/userPoints/:uid", async (req, res) => {
    try {
        const uid = req.params.uid;
        userImp
            .getUserPoints(uid)
            .then((list) => {
                res.status(200).json(func.responseModel({ data: list }));
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

router.get("/auth/me", async (req, res) => {
    try {
        const token = func.body(req).headers.authorization;
        userImp
            .verifyUser(token)
            .then((user) => {
                res.status(200).json(
                    func.responseModel({
                        isSuccess: true,
                        data: user,
                    })
                );
            })
            .catch((error) => {
                API.createLog(error, req, res, 500, logModule);
                res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
            });
    } catch (error) {
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
    }
});

router.put("/auth/me", async (req, res) => {
    try {
        const token = func.body(req).headers.authorization;
        userImp
            .updateUser(token, func.body(req).data)
            .then((user) => {
                res.status(200).json(
                    func.responseModel({
                        isSuccess: true,
                        data: user,
                    })
                );
            })
            .catch((error) => {
                API.createLog(error, req, res, 500, logModule);
                res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
            });
    } catch (error) {
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
    }
});

router.post("/auth/avatar", upload.single("avatar"), async (req, res) => {
    try {
        const token = func.body(req).headers.authorization;

        if (!req.file) {
            return res.status(400).json(func.responseModel({ isSuccess: false, responseMessage: "No file uploaded" }));
        }

        userImp.uploadAvatar(token, req.file).then((result) => {
            res.status(200).json(
                func.responseModel({
                    isSuccess: true,
                    responseMessage: "Avatar uploaded successfully",
                    data: result,
                })
            );
        });
    } catch (error) {
        API.createLog(error, req, res, 500, logModule);
        res.status(500).json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
    }
});

export default router;
