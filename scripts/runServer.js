const readline = require("readline");
const json = require("json");

const apiURL = "https://fdceviu35h.execute-api.us-east-1.amazonaws.com/default-stage/manage-server"

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

rl.question("Would you like to start or stop the server? ", async (response) => {
    console.log(`You have chosen to ${response} the server`);

    let didFail = false;

    let fetchParameters = {
        method: "POST",
        body: JSON.stringify({
            "action":response,
            "api-key":"245988ed-6ede-4e1c-80aa-1e005f803073"
        }),
        headers: {
            "Content-Type" : "application/json"
        }
    }

    await fetch(apiURL, fetchParameters)
        .then(response => {
            console.log(response.status)
            if (Math.floor(response.status /100 ) !== 2) {
                console.log(Math.floor(response.status) / 100)
                didFail = true;
            }
            return response.json();
        })
        .then(async (body) => {
            console.log(body);
            if (didFail) {
                throw body;
            }
            console.log("Congrats, the operation worked! ", body);
            const delay = (milliseconds) => {
                return new Promise((resolve) => {
                    setTimeout(resolve, milliseconds);
                });
            };

            await delay(20000)
        })
        .catch(err => {
            console.log("Uh-oh! Looks like there was an issue: \n" + err.message);
        })

    rl.close();
});