import * as fb from "../configuration/firebase.js";
import { ref, uploadBytes, getDownloadURL } from "firebase/storage";

function uploadFile({ filename, file, fileBuffer }) {
    return new Promise(async (resolve, reject) => {
        const storageRef = ref(fb.default.storage, `${filename}`);
        const contentType = file.mimetype;
        const metadata = { contentType };

        uploadBytes(storageRef, fileBuffer, metadata).then((up) => {
            getDownloadURL(storageRef).then((url) => {
                resolve({
                    file: file,
                    downloadUrl: url,
                    metadata: up.metadata,
                });
            });
        });
    });
}

export { uploadFile };
