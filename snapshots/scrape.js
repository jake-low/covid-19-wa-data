const CDP = require("chrome-remote-interface");

const delay = ms => new Promise(resolve => setTimeout(resolve, ms))

async function scrape(url) {
    let client;

    try {
        client = await CDP();

        const {Page, Runtime} = client;

        await Page.enable();
        await Page.navigate({ url });
        await Page.loadEventFired();

        await delay(5000);

        const result = await Runtime.evaluate({
          expression: "document.documentElement.outerHTML"
        });

        const html = result.result.value;

        console.log(html);
    } catch (err) {
        console.error(err);
    } finally {
        if (client) {
            await client.close();
        }
    }
}

scrape(process.argv[2]);
