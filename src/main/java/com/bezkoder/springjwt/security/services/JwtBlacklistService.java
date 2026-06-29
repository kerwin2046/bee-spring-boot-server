package com.bezkoder.springjwt.security.services;

import java.util.Date;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;

import java.security.Key;

/**
 * 基于内存的 JWT 黑名单服务。
 * 用于在用户登出时使 access token 立即失效，直到 token 自身过期后自动清理。
 */
@Service
public class JwtBlacklistService {
  private static final Logger logger = LoggerFactory.getLogger(JwtBlacklistService.class);

  @Value("${bezkoder.app.jwtSecret}")
  private String jwtSecret;

  @Value("${bezkoder.app.jwtExpirationMs}")
  private long jwtExpirationMs;

  // token -> 过期时间戳(毫秒)
  private final Map<String, Long> blacklist = new ConcurrentHashMap<>();

  public void blacklistToken(String token) {
    if (token == null || token.isEmpty()) {
      return;
    }
    long expiresAt = resolveExpiration(token);
    blacklist.put(token, expiresAt);
  }

  public boolean isTokenBlacklisted(String token) {
    if (token == null || token.isEmpty()) {
      return false;
    }
    cleanupExpired();
    Long expiresAt = blacklist.get(token);
    if (expiresAt == null) {
      return false;
    }
    if (expiresAt <= System.currentTimeMillis()) {
      blacklist.remove(token);
      return false;
    }
    return true;
  }

  private long resolveExpiration(String token) {
    try {
      Claims claims = Jwts.parserBuilder().setSigningKey(key()).build()
          .parseClaimsJws(token).getBody();
      Date expiration = claims.getExpiration();
      if (expiration != null) {
        return expiration.getTime();
      }
    } catch (Exception e) {
      logger.warn("无法解析 token 过期时间，使用默认过期时长: {}", e.getMessage());
    }
    return System.currentTimeMillis() + jwtExpirationMs;
  }

  private void cleanupExpired() {
    long now = System.currentTimeMillis();
    blacklist.entrySet().removeIf(entry -> entry.getValue() <= now);
  }

  private Key key() {
    return Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtSecret));
  }
}
