<?php
namespace MyApp;

class myFile
{
    public $filename;
    public $filetype;
    public $ext;
    public $data_format_64;

    public function guess_ext_from_filetype($type)
    {
        $filetype_arr = array(
            // picture
            'image/gif' => 'gif',
            'image/jpeg' => 'jpg',
            'image/png' => 'png',
            'image/bmp' => 'bmp',
            'image/pjpeg' => array('jpg','jpeg'),
            'image/svg+xml' => 'svg',
            'image/tiff' => array('tif','tiff'),
            'image/x-png' => 'png',
            // 'image/octet-stream' => 'psd',
            'image/x-icon' => 'ico',
            // video, audio
            'application/vnd.rn-realmedia-vbr' => 'rmvb',
            'audio/basic' => array('au','snd'),
            'audio/mid' => array('mid','rmi'),
            'audio/mpeg' => array('mp3','mp2','mpeg','mpa','mpv2','mpe'),
            'audio/x-mpegurl' => 'm3u',
            'audio/wav' => 'wav',
            'video/avi' => 'avi',
            'video/quicktime' => array('mov','qt'),
            'video/x-msvideo' => 'avi',
            'video/x-sgi-movie' => 'movie',
            // file
            'application/zip' => 'zip',
            'application/msword' => 'doc',
            'application/vnd.ms-excel' => 'xls',
            'application/vnd.ms-powerpoint' => 'ppt',
            'application/vnd.ms-outlook' => 'msg',
            'application/pdf' => 'pdf',
            'application/msaccess' => 'mdb',
            'application/x-javascript' => 'js',
            'application/x-rar-compressed' => 'rar',
            'application/x-zip-compressed' => 'zip',
            'application/x-compress' => 'z',
            'application/x-compressed' => 'tgz',
            'application/x-gzip' => 'gz',
            'application/x-latex' => 'latex',
            'application/x-msdownload' => 'dll',
            'application/x-sh' => 'sh',
            'application/x-shockwave-flash' => 'swf',
            'application/x-tar' => 'tar',
            'application/x-tcl' => 'tcl',
            'application/x-tex' => 'tex',
            'application/x-texinfo' => 'texinfo',
            'application/x-x509-ca-cert' => 'crt',
            'application/zip' => 'zip',
            'application/java' => 'class',
            'application/rtf' => 'rtf',
            'message/rfc822' => array('mhtml','mht','nws'),
            'text/xml' => 'xml',
            'text/css' => 'css',
            'text/plain' => array('txt','log','sql','dat','c','h'),
            'text/html' => array('html','htm','stm'),
            'text/richtext' => 'rtx',
            'text/x-vcard' => 'vcf',
            // mix
            'application/octet-stream' => array('rar','psd','7z','exe','3gp',
                'flv','krc','lrc','chm','sql','con','dat','ini','php','ttf',
                'fon','dll','bin','class'),
            'application/postscript' => array('ps','ai','eps'),
        );
    }
}