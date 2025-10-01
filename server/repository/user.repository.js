import { supabase } from "../configuration/supabase.js";

const userTableName = "user";
const authTableName = "auth";
const pointTrasactionTableName = "pointTransaction";

function getUserById(uid) {
    return new Promise(async (resolve, reject) => {
        try {
            const { data, error } = await supabase.from(userTableName).select("*").eq("uid", uid).eq("statusId", 1).single();

            if (error) {
                reject(error);
            } else {
                resolve(data);
            }
        } catch (error) {
            console.error("Error fetching all users:", error);
            reject(error);
        }
    });
}

function getUserByEmail(email) {
    return new Promise(async (resolve, reject) => {
        try {
            const { data, error } = await supabase.from(authTableName).select("*").eq("email", email).eq("statusId", 1).single();

            if (error) {
                reject(error);
            } else {
                resolve(data);
            }
        } catch (error) {
            reject(error);
        }
    });
}

function createUser(user) {
    return new Promise(async (resolve, reject) => {
        try {
            const { data, error } = await supabase.from(authTableName).insert(user).select().single();
            if (error) {
                reject(error);
            } else {
                resolve(data);
            }
        } catch (error) {
            reject(error);
        }
    });
}

function getUserPoints(uid) {
    return new Promise(async (resolve, reject) => {
        try {
            const { data, error } = await supabase.from(pointTrasactionTableName).select("*").eq("userUid", uid).order("createdDate", { ascending: false });

            if (error) {
                reject(error);
            } else {
                resolve(data);
            }
        } catch (error) {
            reject(error);
        }
    });
}

function getUserByAuthId(uid) {
    return new Promise(async (resolve, reject) => {
        try {
            const { data, error } = await supabase.from(userTableName).select("*").eq("authUid", uid).eq("statusId", 1).single();

            if (error) {
                reject(error);
            } else {
                resolve(data);
            }
        } catch (error) {
            console.error("Error fetching all users:", error);
            reject(error);
        }
    });
}

function updateUser(data) {
    return new Promise(async (resolve, reject) => {
        try {
            const { data: updatedData, error } = await supabase.from(userTableName).update(data).eq("uid", data.uid).select().single();
            if (error) {
                reject(error);
            } else {
                resolve(updatedData);
            }
        } catch (error) {
            reject(error);
        }
    });
}

export { getUserById, getUserByEmail, createUser, getUserPoints, getUserByAuthId, updateUser };
