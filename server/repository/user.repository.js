import { supabase } from "../configuration/supabase.js";

const userTableName = "user";
const authTableName = "auth";

function getUserById(uid) {
  return new Promise(async (resolve, reject) => {
    try {
      const { data, error } = await supabase
        .from(userTableName)
        .select("*")
        .eq("uid", uid)
        .eq("statusId", 1)
        .single();

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
      const { data, error } = await supabase
        .from(authTableName)
        .select("*")
        .eq("email", email)
        .eq("statusId", 1)
        .single();

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

export { getUserById, getUserByEmail, createUser };
