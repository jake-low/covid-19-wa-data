const CDP = require('chrome-remote-interface');

CDP((client) => {
  // Extract used DevTools domains.
  const {Page, Runtime} = client;

  // Enable events on domains we are interested in.
  Promise.all([
    Page.enable()
  ]).then(() => {
    return Page.navigate({url: 'https://www.doh.wa.gov/Emergencies/Coronavirus'});
  });

  // Evaluate outerHTML after page has loaded.
  Page.loadEventFired(() => {
    setTimeout(() => {
      Runtime.evaluate({expression: 'document.body.outerHTML'}).then((result) => {
        console.log(result.result.value);
        client.close();
      });
    }, 5000);
  });
}).on('error', (err) => {
  console.error('Cannot connect to browser:', err);
  process.exit(1);
});
