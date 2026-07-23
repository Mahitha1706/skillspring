using System;
using NUnit.Framework;
using Moq;
using CustomerCommLib;

namespace CustomerCommLib.Tests
{
    [TestFixture]
    public class CustomerCommTests
    {
        private Mock<IMailSender> _mockMailSender;
        private CustomerComm _customerComm;

        [OneTimeSetUp]
        public void Init()
        {
            // Create a mock of IMailSender
            _mockMailSender = new Mock<IMailSender>();

            // Setup the mock so that SendMail returns true when called with any two string arguments
            _mockMailSender
                .Setup(m => m.SendMail(It.IsAny<string>(), It.IsAny<string>()))
                .Returns(true);

            // Inject the mock object into the class under test
            _customerComm = new CustomerComm(_mockMailSender.Object);
        }

        [Test]
        [TestCase] // Using TestCase attribute as requested in Task 2
        public void SendMailToCustomer_WhenInvoked_ReturnsTrue()
        {
            // Act
            bool result = _customerComm.SendMailToCustomer();

            // Assert
            Assert.That(result, Is.True);
            
            // Optional: Verify that SendMail was indeed called with specific parameters
            _mockMailSender.Verify(
                m => m.SendMail("cust123@abc.com", "Some Message"), 
                Times.Once
            );
        }
    }
}
