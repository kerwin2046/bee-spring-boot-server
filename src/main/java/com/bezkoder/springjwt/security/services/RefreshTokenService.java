package com.bezkoder.springjwt.security.services;

import com.bezkoder.springjwt.exception.BusinessException;
import com.bezkoder.springjwt.models.RefreshToken;
import com.bezkoder.springjwt.models.User;
import com.bezkoder.springjwt.repository.RefreshTokenRepository;
import com.bezkoder.springjwt.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Service
public class RefreshTokenService {
    
    @Value("${bezkoder.app.jwtRefreshExpirationMs:86400000}")
    private Long refreshTokenDurationMs;
    
    @Autowired
    private RefreshTokenRepository refreshTokenRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public Optional<RefreshToken> findByToken(String token) {
        return refreshTokenRepository.findByToken(token);
    }
    
    @Transactional
    public RefreshToken createRefreshToken(Long userId) {
        RefreshToken refreshToken = new RefreshToken();
        
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(404, "User not found"));
        
        refreshToken.setUser(user);
        refreshToken.setExpiryDate(Instant.now().plusMillis(refreshTokenDurationMs));
        refreshToken.setToken(UUID.randomUUID().toString());
        
        // 删除该用户之前的refresh token
        refreshTokenRepository.deleteByUser(user);
        
        refreshToken = refreshTokenRepository.save(refreshToken);
        return refreshToken;
    }
    
    public RefreshToken verifyExpiration(RefreshToken token) {
        if (token.getExpiryDate().compareTo(Instant.now()) < 0) {
            refreshTokenRepository.delete(token);
            throw new BusinessException(401, "Refresh token was expired. Please make a new signin request");
        }
        return token;
    }
    
    @Transactional
    public int deleteByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(404, "User not found"));
        return refreshTokenRepository.deleteByUser(user);
    }
    
    @Transactional
    public int deleteByToken(String token) {
        return refreshTokenRepository.deleteByToken(token);
    }
}
