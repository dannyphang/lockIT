import * as taskRepo from "../repository/task.repository.js";
import * as userRepo from "../repository/user.repository.js";

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

function completedTask(user, taskProgress) {
  return new Promise(async (resolve, reject) => {
    try {
      taskRepo
        .getTaskById(taskProgress.taskUid)
        .then((existingTask) => {
          if (existingTask) {
            existingTask.taskStatusId = 2;
            completed = new Date();

            taskRepo
              .updateTaskProgress(taskProgress)
              .then((updatedProgress) => {
                let updateUser = {
                  ...user,
                  scorePoints: user.scorePoint + existingTask.rewardPoints,
                };
                userRepo
                  .updateUser(updateUser)
                  .then((updatedUser) => {
                    resolve({ updatedProgress, updatedUser });
                  })
                  .catch((error) => {
                    reject(error);
                  });
              })
              .catch((error) => {
                reject(error);
              });
          } else {
            reject(new Error("Task not found"));
          }
        })
        .catch((error) => {
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
        startedDate: new Date(),
        taskStatusId: 1, // Active
      };

      taskRepo
        .createNewTaskProgress(newTaskP)
        .then(async (createdTaskProgress) => {
          const list = await taskRepo.getTaskProgressList(user);
          // TODO: return task list
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
