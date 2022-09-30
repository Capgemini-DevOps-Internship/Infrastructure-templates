module.exports = async function (context, req) {
    context.log('JavaScript HTTP trigger function processed a request.');

    const name = (req.query.name || (req.body && req.body.name));
    const responseMessage = name
        ? "Hello, " + name + ". This HTTP triggered function executed successfully."
        : "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response.";
    var url = "https://prod-197.westeurope.logic.azure.com:443/workflows/ebf5ff6797ff4ab3be39cd8ab903c915/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=5nPqcRMukCmYfVwWRKSKiHcW50urtDTcUKBfzXOfcaY";
    request = HttpWebRequest.Create(url);
    response = request.GetResponse();
    reader = new StreamReader(response.GetResponseStream());

    context.res = {
        // status: 200, /* Defaults to 200 */
        body: responseMessage
    };
}