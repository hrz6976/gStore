#ifndef _GRPC_CONTENT_H
#define _GRPC_CONTENT_H

#include <cstdio>
#include <iostream>
#include <string>
#include <map>
#include <vector>
#include "grpc_multipart_parser.h"
#include "grpc_stringpiece.h"
#include <chrono>
#include <string>
#include <sstream>
#include <iomanip>

using namespace std::chrono;

namespace grpc
{
// CTM(name, mime, suffix)
#define CONTENT_TYPES_MAP(CTM)                                             \
    CTM(TEXT_PLAIN,              text/plain,                       txt)    \
    CTM(TEXT_HTML,               text/html,                       html)    \
    CTM(TEXT_CSS,                text/css,                         css)    \
    CTM(APPLICATION_ZIP,         application/zip,                  zip)    \
    CTM(APPLICATION_XML,         application/xml,                  xml)    \
    CTM(APPLICATION_JSON,        application/json,                json)    \
    CTM(APPLICATION_URLENCODED,  application/x-www-form-urlencoded, kv)    \
    CTM(MULTIPART_FORM_DATA,     multipart/form-data,               mp)    \
    CTM(APPLICATION_OCTET_STREAM,application/octet-stream,         bin)

#define X_WWW_FORM_URLENCODED APPLICATION_URLENCODED

enum content_type
{
#define CTM(name, string, suffix)    name,
    CONTENT_TYPE_NONE,
    CONTENT_TYPES_MAP(CTM)
    CONTENT_TYPE_UNDEFINED
#undef CTM
};

class ContentType
{
public:
    static std::string to_str(enum content_type type);

    static std::string to_str_by_suffix(const std::string &suffix);

    static enum content_type to_enum(const std::string &content_type_str);

    static enum content_type to_enum_by_suffix(const std::string &suffix);
};

class UrlEncode
{
public:
    static std::map<std::string, std::string> parse_post_body(const std::string &body);
    
    static bool is_url_encode(const std::string &str)
    {
        return str.find("%") != std::string::npos ||
            str.find("+") != std::string::npos;
    }
};

class MapStringCaseLess {
public:
    bool operator()(const std::string& lhs, const std::string& rhs) const {
        return strcasecmp(lhs.c_str(), rhs.c_str()) < 0;
    }
};

class Timestamp {
public:
    Timestamp()
        : micro_sec_since_epoch_(0)
    {}

    Timestamp(uint64_t micro_sec_since_epoch)
        : micro_sec_since_epoch_(micro_sec_since_epoch)
    {}

    Timestamp(const Timestamp &that)
        : micro_sec_since_epoch_(that.micro_sec_since_epoch_)
    {}
    
    static Timestamp now();

    std::string to_format_str() const;

    std::string to_format_str(const char *fmt) const;
    
    static const int k_micro_sec_per_sec = 1000 * 1000;
private:
    uint64_t micro_sec_since_epoch_;
};

using Form = std::map<std::string, std::pair<std::string, std::string>>;

class MultiPartForm 
{
public:
    Form parse_multipart(const StringPiece &body) const;

    void set_boundary(std::string &&boundary)
    { boundary_ = std::move(boundary); }

    void set_boundary(const std::string &boundary)
    { boundary_ = boundary; }

public:
    static const std::string k_default_boundary;

    MultiPartForm();
private:
    static int header_field_cb(multipart_parser *parser, const char *buf, size_t len);

    static int header_value_cb(multipart_parser *parser, const char *buf, size_t len);

    static int part_data_cb(multipart_parser *parser, const char *buf, size_t len);

    static int part_data_begin_cb(multipart_parser *parser);

    static int headers_complete_cb(multipart_parser *parser);

    static int part_data_end_cb(multipart_parser *parser);

    static int body_end_cb(multipart_parser *parser);

private:
    std::string boundary_;

    multipart_parser_settings settings_;
};

class MultiPartEncoder 
{
public:
    using ParamList = std::vector<std::pair<std::string, std::string>>;
    using FileList = std::vector<std::pair<std::string, std::string>>;

    MultiPartEncoder();

    ~MultiPartEncoder() = default;

    void add_param(const std::string &name, const std::string &value);

    void add_file(const std::string &file_name, const std::string &file_path);

    const ParamList &params() const { return params_; }

    const FileList &files() const { return files_; }

    const std::string &boundary() const { return boundary_; }

    void set_boundary(const std::string &boundary);

    void set_boundary(std::string &&boundary);

private:
    std::string boundary_;
    std::string content_;
    std::vector<std::pair<std::string, std::string>> params_;
    std::vector<std::pair<std::string, std::string>> files_;
};

} // namespace grpc

#endif //_GRPC_CONTENT_H