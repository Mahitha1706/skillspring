using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApi_Handson.Filters;
using WebApi_Handson.Models;

namespace WebApi_Handson.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Route("Emp")] // Handson 2 requirement: Route alias
    [Authorize(Roles = "Admin,POC")] // Handson 5 requirement: Role-based authorization
    public class EmployeeController : ControllerBase
    {
        private static List<Employee> _employeeList = new List<Employee>
        {
            new Employee
            {
                Id = 1,
                Name = "John Doe",
                Salary = 60000,
                Permanent = true,
                Department = new Department { Id = 1, DepartmentName = "IT" },
                Skills = new List<Skill> { new Skill { Id = 1, Name = "C#" }, new Skill { Id = 2, Name = "ASP.NET Web API" } },
                DateOfBirth = new DateTime(1995, 5, 15)
            },
            new Employee
            {
                Id = 2,
                Name = "Jane Smith",
                Salary = 75000,
                Permanent = true,
                Department = new Department { Id = 2, DepartmentName = "HR" },
                Skills = new List<Skill> { new Skill { Id = 3, Name = "Recruitment" } },
                DateOfBirth = new DateTime(1993, 8, 20)
            }
        };

        private List<Employee> GetStandardEmployeeList()
        {
            return _employeeList;
        }

        [HttpGet]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status401Unauthorized)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public ActionResult<List<Employee>> GetStandard()
        {
            return Ok(GetStandardEmployeeList());
        }

        [HttpGet("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public ActionResult<Employee> Get(int id)
        {
            var emp = _employeeList.FirstOrDefault(e => e.Id == id);
            if (emp == null)
            {
                return NotFound($"Employee with ID {id} not found.");
            }
            return Ok(emp);
        }

        [HttpPost]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Employee> Post([FromBody] Employee emp)
        {
            if (emp == null)
            {
                return BadRequest("Invalid employee data.");
            }
            emp.Id = _employeeList.Max(e => e.Id) + 1;
            _employeeList.Add(emp);
            return CreatedAtAction(nameof(Get), new { id = emp.Id }, emp);
        }

        [HttpPut("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult<Employee> Put(int id, [FromBody] Employee emp)
        {
            // Handson 4 requirement: check if id <= 0 or not available
            if (id <= 0)
            {
                return BadRequest("Invalid employee id");
            }

            var existingEmp = _employeeList.FirstOrDefault(e => e.Id == id);
            if (existingEmp == null)
            {
                return BadRequest("Invalid employee id");
            }

            existingEmp.Name = emp.Name;
            existingEmp.Salary = emp.Salary;
            existingEmp.Permanent = emp.Permanent;
            existingEmp.Department = emp.Department;
            existingEmp.Skills = emp.Skills;
            existingEmp.DateOfBirth = emp.DateOfBirth;

            return Ok(existingEmp);
        }

        [HttpDelete("{id}")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public ActionResult Delete(int id)
        {
            if (id <= 0)
            {
                return BadRequest("Invalid employee id");
            }

            var emp = _employeeList.FirstOrDefault(e => e.Id == id);
            if (emp == null)
            {
                return BadRequest("Invalid employee id");
            }

            _employeeList.Remove(emp);
            return Ok(new { Message = $"Employee {id} deleted successfully." });
        }

        [HttpGet("throw-error")]
        [CustomExceptionFilter]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public ActionResult ThrowException()
        {
            throw new Exception("Test exception for CustomExceptionFilter demonstration.");
        }
    }
}
