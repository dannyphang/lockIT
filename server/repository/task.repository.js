import { supabase } from "../configuration/supabase.js";

const taskTableName = "task";

function getAllTask() {
    return new Promise(async (resolve, reject) => {
        try {
            const { data, error } = await supabase.from(taskTableName).select("*").eq("statusId", 1);
            if (error) {
                throw error;
            }
            resolve(data);
        } catch (error) {
            reject(error);
        }
    });
}

function getTaskById(uid) {
    return new Promise(async (resolve, reject) => {
        try {
            const { data, error } = await supabase.from(taskTableName).select("*").eq("uid", uid).single();
            if (error) {
                throw error;
            }
            resolve(data);
        } catch (error) {
            reject(error);
        }
    });
}

export { getAllTask, getTaskById };
