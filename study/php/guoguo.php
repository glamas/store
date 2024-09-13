<?php
// header("Content-type: text/html; charset=utf-8");

function get_detail($tracking_no)
{
    /*
    API 说明： 本脚本使用菜鸟裹裹[http://www.guoguo-app.com/]来查询快递信息
        经过实验，可以实际使用
    流程：
        1. 初始化curl，设置header和body同时返回，用于获取cookie
        2. 请求mtop.user.getusersimple，获取无令牌的cookie
        3. 请求mtop.cnwireless.cnlogisticdetailservice.wapquerylogisticpackagebymailno，获取cookie里的_m_h5_tk，生成有效令牌
        4. 再次请求mtop.cnwireless.cnlogisticdetailservice.wapquerylogisticpackagebymailno，带上令牌，得到快递信息
    */
    if( ! $tracking_no ){
        $tracking_no = "189107775160";  // 订单号
        // return 0;
    }

    // 初始化curl
    $headers = array(
        'Referer: http://www.guoguo-app.com/',
        'User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36',
        // 'x-requested-with: XMLHttpRequest',
        "Accept: application/json",
        // "Content-type: application/x-www-form-urlencoded",
    );
    $ch = curl_init();

    //curl_setopt($ch,CURLOPT_URL,$url);    // 在后面设置url
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    // curl_setopt($ch, CURLOPT_COOKIE, $cookies);


    list($msec, $sec) = explode(' ', microtime());
    $now = (float)sprintf('%.0f', (floatval($msec) + floatval($sec)) * 1000);
    $appKey = "12574478";
    $data_inside = json_decode("{}");
    $sign = md5("undefined&".$now."&".$appKey."&".json_encode($data_inside));
    // echo $sign . "\n";
    $data = array(
        "jsv" => "2.4.2",
        "appKey" => $appKey,
        "t" => $now,
        "sign" => $sign,
        "api" => "mtop.user.getUserSimple",
        "v" => "1.0",
        "noAutoTrack" => "1",
        "maxRetryTimes" => "1",
        "dataType" => "json",
        "type" => "originaljson",
        "data" => json_encode($data_inside),
    );
    $url = "http://h5api.m.taobao.com/h5/mtop.user.getusersimple/1.0/?".http_build_query($data);
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_HEADER, 1);    // 获得header里的cookie
    $response = curl_exec($ch);
    if($response === FALSE ){
        echo "CURL Error:".curl_error($ch);
    } else {
        // echo $response."\n";
        list($h, $b) = explode("\r\n\r\n", $response, 2);
        $cookies = "";
        $cookie_dict = array();
        $matches = array();
        $cookies_array = preg_match_all('/Set-Cookie: (.*?);/m', $h, $matches) ? $matches[1] : array();
        foreach($cookies_array as $v){
            $kv = explode("=", $v);
            $cookie_dict[$kv[0]] = $kv[1];
        }
        foreach($cookie_dict as $k => $v){
            $cookies .= $k . "=" . $v . ";";
        }
        $cookies = rtrim($cookies,";");
        // echo $cookies . "\n";
        curl_setopt($ch, CURLOPT_COOKIE, $cookies);
    
        list($msec, $sec) = explode(' ', microtime());
        $now = (float)sprintf('%.0f', (floatval($msec) + floatval($sec)) * 1000);
        $appKey = "12574478";
        $data_inside = array("mailNo" => $tracking_no,"cpCode" => "");
        $sign = md5("undefined&".$now."&".$appKey."&".json_encode($data_inside));
        // echo $sign . "\n";
        $data = array(
            "jsv" => "2.4.2",
            "appKey" => $appKey,
            "t" => $now,
            "sign" => $sign,
            "api" => "mtop.cnwireless.CNLogisticDetailService.wapqueryLogisticPackageByMailNo",
            "v" => "1.0",
            "AntiCreep" => "true",
            "type" => "originaljson",
            "dataType" => "json",
            "data" => json_encode($data_inside),
        );
        $url = "http://h5api.m.taobao.com/h5/mtop.cnwireless.cnlogisticdetailservice.wapquerylogisticpackagebymailno/1.0/?".http_build_query($data);
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_HEADER, 1);
        $response = curl_exec($ch);
        if($response === FALSE ){
            echo "CURL Error:".curl_error($ch);
        } else {
            // echo $response."\n";
            list($h,$b) = explode("\r\n\r\n", $response, 2);
            $m_h5_tk = "undefined";
            $matches = array();
            $cookies_array = preg_match_all('/Set-Cookie: (.*?);/m', $h, $matches) ?  $matches[1] : array();
            foreach($cookies_array as $v){
                $kv = explode("=", $v);
                $cookie_dict[$kv[0]] = $kv[1];
                if ($kv[0] == "_m_h5_tk"){
                    $m_h5_tk = explode("_", $kv[1])[0];
                }
            }
            foreach($cookie_dict as $k => $v){
                $cookies .= $k . "=" . $v . ";";
            }
            $cookies = rtrim($cookies,";");
            curl_setopt($ch, CURLOPT_COOKIE, $cookies);
            // echo $cookies."\n";
            // echo $m_h5_tk."\n";
            $sign = md5($m_h5_tk."&".$now."&".$appKey."&".json_encode($data_inside));
            $data["sign"] = $sign;
            // print_r($data) .'\n';
            $url = "http://h5api.m.taobao.com/h5/mtop.cnwireless.cnlogisticdetailservice.wapquerylogisticpackagebymailno/1.0/?".http_build_query($data);
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_HEADER, 0);
            $response = curl_exec($ch);
            if($response === FALSE ){
                echo "CURL Error:".curl_error($ch);
            } else {
                // echo $response."\n";
                $json_data = json_decode($response, true);
                if (isset($json_data["data"]["transitList"])){
                    foreach($json_data["data"]["transitList"] as $k => $v){
                        echo $v["time"] ." : ". $v["message"] . "\n";
                    }
                } else {
                    echo "暂无查询记录\n";
                }
            }
        }
    }
    curl_close($ch);
    // return array();
}

get_detail("SUR700004835257");