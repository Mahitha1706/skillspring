using System;
using NUnit.Framework;
using CalcLibrary;

namespace CalcLibrary.Tests
{
    [TestFixture]
    public class SimpleCalculatorTests
    {
        private SimpleCalculator _calculator;

        [SetUp]
        public void Init()
        {
            // Initialize the calculator instance before each test
            _calculator = new SimpleCalculator();
        }

        [TearDown]
        public void Cleanup()
        {
            // Reset calculator values after each test runs
            _calculator.AllClear();
            _calculator = null;
        }

        // Test addition functionality using TestCase for parameterized inputs
        [TestCase(10, 20, 30)]
        [TestCase(-5, 5, 0)]
        [TestCase(0, 0, 0)]
        [TestCase(-1.5, -2.5, -4.0)]
        public void Addition_ValidInputs_ReturnsExpectedSum(double a, double b, double expected)
        {
            double result = _calculator.Addition(a, b);
            Assert.That(result, Is.EqualTo(expected));
        }

        [TestCase(50, 20, 30)]
        [TestCase(0, 5, -5)]
        [TestCase(-5, -5, 0)]
        public void Subtraction_ValidInputs_ReturnsExpectedDifference(double a, double b, double expected)
        {
            double result = _calculator.Subtraction(a, b);
            Assert.That(result, Is.EqualTo(expected));
        }

        [TestCase(5, 6, 30)]
        [TestCase(-2, 4, -8)]
        [TestCase(0, 100, 0)]
        public void Multiplication_ValidInputs_ReturnsExpectedProduct(double a, double b, double expected)
        {
            double result = _calculator.Multiplication(a, b);
            Assert.That(result, Is.EqualTo(expected));
        }

        [TestCase(20, 5, 4)]
        [TestCase(-15, 3, -5)]
        [TestCase(7, 2, 3.5)]
        public void Division_ValidInputs_ReturnsExpectedQuotient(double a, double b, double expected)
        {
            double result = _calculator.Division(a, b);
            Assert.That(result, Is.EqualTo(expected));
        }

        [Test]
        public void Division_DivideByZero_ThrowsArgumentException()
        {
            // Test that division by zero throws an ArgumentException
            var ex = Assert.Throws<ArgumentException>(() => _calculator.Division(10, 0));
            Assert.That(ex.Message, Is.EqualTo("Second Parameter Can't be Zero"));
        }

        [Test]
        public void GetResult_AfterOperations_HoldsCorrectResultValue()
        {
            _calculator.Addition(15, 25);
            Assert.That(_calculator.GetResult, Is.EqualTo(40));
        }

        [Test]
        [Ignore("Demonstrating the Ignore attribute for NUnit study objectives.")]
        public void IgnoredTest_WillNotBeExecuted()
        {
            Assert.Fail("This test should not run as it is ignored.");
        }
    }
}
