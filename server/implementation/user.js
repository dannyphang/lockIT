import * as func from "../shared/function.js";
import * as constant from "../shared/constant.js";
import * as userRepo from "../repository/user.repository.js";
import * as taskRepo from "../repository/task.repository.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import "crypto";
import * as attachmentImp from "./attachment.js";
import fs from "fs";

function getUser(uid) {
    return new Promise(async (resolve, reject) => {
        try {
            userRepo
                .getUserById(uid)
                .then((user) => {
                    resolve(user);
                })
                .catch((error) => {
                    reject(error);
                });
        } catch (error) {
            reject(error);
        }
    });
}

function signJwt(user) {
    const secret = process.env.JWT_TOKEN_SECRET;
    if (!secret) {
        throw new Error("Missing JWT_TOKEN_SECRET env");
    }

    // Minimal payload — only what you need
    const payload = {
        uid: user.uid, // Supabase row id (uuid)
        username: user.username,
        email: user.email,
    };

    // Optional metadata
    const options = {
        expiresIn: process.env.JWT_EXPIRES_IN || "7d",
        issuer: "lockgate-api", // adjust to your service name
        // audience: "lockgate-app", // optional
        // subject: String(user.id), // optional
    };

    return jwt.sign(payload, secret, options);
}

function login(email, password) {
    return new Promise(async (resolve, reject) => {
        try {
            const user = await userRepo.getUserByEmail(email);
            if (!user) {
                return reject("User not found");
            }

            const ok = await bcrypt.compare(password, user.password);
            if (!ok) {
                return reject("Invalid credentials");
            }

            const token = signJwt(user);

            resolve(token);
        } catch (error) {
            reject(error);
        }
    });
}

function register(userData) {
    return new Promise(async (resolve, reject) => {
        try {
            const { username, email, password } = userData;
            if (!username || !email || !password) {
                return reject("Missing required fields");
            }
            // const existingUser = await userRepo.getUserByEmail(email);
            // if (existingUser) {
            //     return reject("Email already in use");
            // }
            // console.log(existingUser);
            const passwordHash = await bcrypt.hash(password, 12);

            const newUser = {
                username,
                email,
                password: passwordHash,
                statusId: 1, // active
            };
            const createdUser = await userRepo.createUser(newUser);

            const token = signJwt(createdUser);
            resolve(token);
        } catch (error) {
            reject(error);
        }
    });
}

function getUserPoints(uid) {
    return new Promise(async (resolve, reject) => {
        try {
            const pointsList = await userRepo.getUserPoints(uid);

            const taskPoints = await Promise.all(
                pointsList.map(async (point) => {
                    if (!point.taskUid) return point; // default
                    const task = await taskRepo.getTaskById(point.taskUid);

                    return {
                        ...point,
                        task: task.task,
                        title: task.title,
                        source: task.source,
                        description: task.description,
                        earnedPoint: task.rewardPoints,
                    };
                })
            );

            resolve(taskPoints);
        } catch (error) {
            reject(error);
        }
    });
}

function verifyUser(token) {
    return new Promise(async (resolve, reject) => {
        try {
            const decoded = jwt.verify(token, process.env.JWT_TOKEN_SECRET);
            const user = await userRepo.getUserByAuthId(decoded.uid);

            resolve(user);
        } catch (error) {
            console.log(error);
            reject(error);
        }
    });
}

function uploadAvatar(token, file) {
    return new Promise(async (resolve, reject) => {
        try {
            const user = await verifyUser(token);
            if (!user) {
                return reject("User not found");
            }

            const path = `lockIT/avatar/`;
            const filename = `${path}${user.uid}`;

            const fileBuffer = fs.readFileSync(file.path);

            attachmentImp
                .uploadFile({ filename, file, fileBuffer })
                .then((result) => {
                    resolve(result.downloadUrl);
                })
                .catch((error) => {
                    reject(error);
                });
        } catch (error) {
            reject(error);
        }
    });
}

function updateUser(token, data) {
    return new Promise(async (resolve, reject) => {
        try {
            const user = await verifyUser(token);
            if (!user) {
                return reject("User not found");
            }
            const updatedUser = await userRepo.updateUser({ uid: user.uid, ...data });
            resolve(updatedUser);
        } catch (error) {
            reject(error);
        }
    });
}

export { getUser, login, register, getUserPoints, verifyUser, uploadAvatar, updateUser };
