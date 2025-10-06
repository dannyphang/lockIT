import * as taskRepo from "../repository/task.repository.js";
import * as userRepo from "../repository/user.repository.js";

function getAllTask(user = null) {
    return new Promise(async (resolve, reject) => {
        try {
            if (user) {
                const selectedList = await taskRepo.getTaskProgressList(user);
                const allTaskList = await taskRepo.getAllTask();
                // if selected, set isSelected true, else false
                const mergedList = allTaskList.map((task) => {
                    const taskProgress = selectedList.find((selected) => selected.taskUid === task.uid && selected.statusId === 1);
                    return { ...task, taskProgress: taskProgress };
                });
                resolve(mergedList);
            } else {
                const allTaskList = await taskRepo.getAllTask();
                resolve(allTaskList);
            }
        } catch (error) {
            reject(error);
        }
    });
}

function completedTask(user, task) {
    return new Promise(async (resolve, reject) => {
        try {
            let taskProgress = task.taskProgress;
            taskProgress.taskStatusId = 2;
            taskProgress.completedDate = new Date();

            taskRepo
                .updateTaskProgress(taskProgress)
                .then((updatedProgress) => {
                    let updateUser = {
                        ...user,
                        scorePoint: user.scorePoint + task.rewardPoints,
                    };
                    userRepo
                        .updateUser(updateUser)
                        .then(async (updatedUser) => {
                            let newTransaction = {
                                userUid: user.uid,
                                taskUid: task.uid,
                                typeId: 1,
                            };
                            await taskRepo.createPointTransaction(newTransaction);
                            resolve(taskProgress);
                        })
                        .catch((error) => {
                            reject(error);
                        });
                })
                .catch((error) => {
                    console.log("Error updating task progress:", error);
                    reject(error);
                });
        } catch (error) {
            reject(error);
        }
    });
}

function selectTask(user, taskUid) {
    return new Promise(async (resolve, reject) => {
        try {
            const newTaskP = {
                userUid: user.uid,
                taskUid: taskUid,
                statusId: 1,
                taskStatusId: 1, // new
                startedDate: new Date(),
            };

            taskRepo
                .createNewTaskProgress(newTaskP)
                .then(async (createdTaskProgress) => {
                    resolve(createdTaskProgress);
                })
                .catch((error) => {
                    reject(error);
                });
        } catch (error) {
            reject(error);
        }
    });
}

export { getAllTask, completedTask, selectTask };
