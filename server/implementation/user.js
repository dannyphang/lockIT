import * as func from "../shared/function.js";
import * as constant from "../shared/constant.js";
import * as userRepo from "../repository/user.repository.js";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";
import "crypto";

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
    const buf = new Uint8Array(64);
    crypto.getRandomValues(buf);
    const tempString = Buffer.from(buf).toString("base64url"); // url-safe
    const secret = process.env.JWT_SECRET || tempString;
    if (!secret) {
        throw new Error("Missing JWT_SECRET env");
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

            const ok = await bcrypt.compare(password, user.password_hash);

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

export { getUser, login, register };
