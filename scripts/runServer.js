const readline = require("readline");
const json = require("json");
import key from "./secret";

const postApiUrl = "https://fdceviu35h.execute-api.us-east-1.amazonaws.com/default-stage/manage-server"
const getApiUrl = "https://fdceviu35h.execute-api.us-east-1.amazonaws.com/default-stage/server-status"

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

const getIPv4Addr = () => {

    return new Promise((resolve, reject) => {
        const fetchParameters = {
            method: "GET",
            body: {
                "api-key":key
            },
            headers: {
                "Content-Type": "application/json"
            }
        }
        return fetch(getApiUrl, fetchParameters)
            .then(response => {
                return response.json();
            })
            .then(status => {
                console.log(status.message + "\nPlease allow the server ~30 seconds to startup before trying to connect.");
                resolve(status.message);
            })
            .catch(err => {
                console.log("There was an issue when trying to retrieve the IPv4Addr: ", err);
                reject(err);
            })
    })
}
rl.question("Would you like to start or stop the server? ", async (response) => {
    console.log(`You have chosen to ${response} the server`);

    let didFail = false;

    let fetchParameters = {
        method: "POST",
        body: JSON.stringify({
            "action":response,
            "api-key":key
        }),
        headers: {
            "Content-Type" : "application/json"
        }
    }

    await fetch(postApiUrl, fetchParameters)
        .then(response => {
            if (Math.floor(response.status /100 ) !== 2) {
                didFail = true;
            }
            return response.json();
        })
        .then(async (body) => {
            if (didFail) {
                throw body;
            }
            console.log("Congrats, the operation worked! ", body);
            const delay = (milliseconds) => {
                return new Promise((resolve) => {
                    setTimeout(resolve, milliseconds);
                });
            };
            if (response === "start") {
                console.log("Beginning retrieval of server IP.");
                return await delay(3000)
            }
        })
        .then(() => {
            if (response === "start") {
                return getIPv4Addr()
            }
        })
        .catch(err => {
            console.log("Uh-oh! Looks like there was an issue: \n" + err.message);
        })

    rl.close();
});