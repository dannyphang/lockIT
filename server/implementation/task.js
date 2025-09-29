import * as taskRepo from "../repository/task.repository.js";

function getAllTask() {
    return new Promise(async (resolve, reject) => {
        try {
            taskRepo
                .getAllTask()
                .then((list) => {
                    resolve(list);
                })
                .catch((error) => {
                    reject(error);
                });
        } catch (error) {
            reject(error);
        }
    });
}

export { getAllTask };
