import { Router } from "express";
import express from "express";
const router = Router();
import * as userImp from "../implementation/user.js";
import * as API from "../shared/service.js";
import * as func from "../shared/function.js";

router.use(express.json());

const logModule = "user";

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
        res
          .status(500)
          .json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
      });
  } catch (error) {
    API.createLog(error, req, res, 500, logModule);
    res
      .status(500)
      .json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
  }
});

// POST /auth/login
router.post("/login", async (req, res) => {
  try {
    const userData = func.body(req).data;
    console.log(userData);
    if (!userData.email || !userData.password) {
      return res
        .status(400)
        .json(func.responseModel({ isSuccess: false, responseMessage: "Missing credentials" }));
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
        return res
          .status(401)
          .json(func.responseModel({ isSuccess: false, responseMessage: "Invalid credentials" }));
      });
  } catch (error) {
    API.createLog(error, req, res, 500, logModule);
    res
      .status(500)
      .json(func.responseModel({ isSuccess: false, responseMessage: error.message || error }));
  }
});

export default router;
