/*
应用名称：自用微博国际版去广告脚本
*/

var body = $response.body;
var url = $request.url;
if (url.includes("/ad/")) {
    body = "";
}
$done({body});