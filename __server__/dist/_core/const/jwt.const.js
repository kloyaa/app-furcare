"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.JwtExpiration = void 0;
var JwtExpiration;
(function (JwtExpiration) {
    JwtExpiration["ACCESS_TOKEN"] = "15m";
    JwtExpiration["REFRESH_TOKEN"] = "7d";
    JwtExpiration["EMAIL_VERIFICATION"] = "1h";
    JwtExpiration["PASSWORD_RESET"] = "30m";
})(JwtExpiration || (exports.JwtExpiration = JwtExpiration = {}));
