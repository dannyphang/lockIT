import { supabase } from "../configuration/supabase.js";

const taskTableName = "task";
const taskProgressTableName = "taskProgress";

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
      const { data, error } = await supabase
        .from(taskTableName)
        .select("*")
        .eq("uid", uid)
        .single();
      if (error) {
        throw error;
      }
      resolve(data);
    } catch (error) {
      reject(error);
    }
  });
}

function getTaskProgressByUid(uid) {
  return new Promise(async (resolve, reject) => {
    try {
      const { data, error } = await supabase
        .from(taskProgressTableName)
        .select("*")
        .eq("uid", uid)
        .eq("statusId", 1)
        .single();

      if (error) {
        reject(error);
      }
      resolve(data);
    } catch (error) {
      reject(error);
    }
  });
}

function getTaskProgressList(user) {
  return new Promise(async (resolve, reject) => {
    try {
      const { data, error } = await supabase
        .from(taskProgressTableName)
        .select("*")
        .eq("userUid", user.uid)
        .eq("statusId", 1);
      if (error) {
        reject(error);
      }
      resolve(data);
    } catch (error) {
      reject(error);
    }
  });
}

function updateTaskProgress(taskProgress) {
  return new Promise(async (resolve, reject) => {
    try {
      const { data, error } = await supabase
        .from(taskProgressTableName)
        .update(taskProgress)
        .eq("uid", taskProgress.uid)
        .select()
        .single();
      if (error) {
        reject(error);
      }
      resolve(data);
    } catch (error) {
      reject(error);
    }
  });
}

function createNewTaskProgress(taskProgress) {
  return new Promise(async (resolve, reject) => {
    try {
      const { data, error } = await supabase
        .from(taskProgressTableName)
        .insert(taskProgress)
        .select()
        .single();
      if (error) {
        reject(error);
      }
      resolve(data);
    } catch (error) {
      reject(error);
    }
  });
}

export {
  getAllTask,
  getTaskById,
  getTaskProgressByUid,
  getTaskProgressList,
  updateTaskProgress,
  createNewTaskProgress,
};
