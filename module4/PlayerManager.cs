using System;
using System.Collections.Generic;
using NUnit.Framework;
using Moq;
using MagicFilesLib;

namespace DirectoryExplorer.Tests
{
    [TestFixture]
    public class DirectoryExplorerTests
    {
        private Mock<IDirectoryExplorer> _mockExplorer;
        private readonly string _file1 = "file.txt";
        private readonly string _file2 = "file2.txt";
        private string _testPath;

        [OneTimeSetUp]
        public void Init()
        {
            _testPath = @"C:\MockPath";
            _mockExplorer = new Mock<IDirectoryExplorer>();

            // Setup the mock to return a collection of hardcoded file names
            var mockFiles = new List<string> { _file1, _file2 };
            _mockExplorer.Setup(e => e.GetFiles(_testPath)).Returns(mockFiles);
        }

        [Test]
        [TestCase] // Using TestCase attribute as requested in Task 2
        public void GetFiles_MockedPath_ReturnsCorrectFiles()
        {
            // Act
            ICollection<string> files = _mockExplorer.Object.GetFiles(_testPath);

            // Assert
            Assert.That(files, Is.Not.Null);
            Assert.That(files.Count, Is.EqualTo(2));
            Assert.That(files, Contains.Item(_file1));
            Assert.That(files, Contains.Item(_file2));
        }
    }
}
