using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using WebApi_Handson.Models;

namespace WebApi_Handson.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [AllowAnonymous]
    public class AuthController : ControllerBase
    {
        private string GenerateJSONWebToken(int userId, string userRole)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("mysuperdupersecretmysuperdupersecret"));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Role, userRole),
                new Claim("UserId", userId.ToString())
            };

            var token = new JwtSecurityToken(
                issuer: "mySystem",
                audience: "myUsers",
                claims: claims,
                expires: DateTime.Now.AddMinutes(10),
                signingCredentials: credentials);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        [HttpPost("login")]
        public IActionResult Login([FromBody] LoginModel model)
        {
            // Simple credential verification for demo
            if (model.Username == "admin" && model.Password == "password")
            {
                var tokenString = GenerateJSONWebToken(101, "Admin");
                return Ok(new { Token = tokenString });
            }
            else if (model.Username == "poc" && model.Password == "password")
            {
                var tokenString = GenerateJSONWebToken(102, "POC");
                return Ok(new { Token = tokenString });
            }

            return Unauthorized(new { Message = "Invalid credentials." });
        }

        [HttpGet("token")]
        public IActionResult GetToken()
        {
            var tokenString = GenerateJSONWebToken(1, "Admin");
            return Ok(new { Token = tokenString });
        }
    }
}
