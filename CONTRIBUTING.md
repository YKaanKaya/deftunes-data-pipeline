# Contributing to DeFtunes Data Pipeline

Thank you for considering contributing to the DeFtunes Data Pipeline project! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please follow these guidelines when contributing:
- Be respectful and inclusive in your communication
- Provide constructive feedback
- Focus on the project goals and requirements

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion for improvement:
1. Check if the issue already exists in the GitHub Issues
2. If not, create a new issue with:
   - A clear title and description
   - Steps to reproduce (for bugs)
   - Expected behavior
   - Actual behavior
   - Screenshots or logs if applicable

### Development Process

1. Fork the repository
2. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes, following code style guidelines
4. Add tests for new functionality
5. Run existing tests:
   ```bash
   pytest
   ```
6. Commit your changes with clear commit messages:
   ```bash
   git commit -m "Add feature: description of your changes"
   ```
7. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
8. Submit a pull request to the main repository

### Pull Request Guidelines

- Include a clear description of the changes
- Link to any relevant issues
- Ensure all tests pass
- Make sure your code follows project style guidelines
- Keep changes focused on a single concern

## Development Environment Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/deftunes-data-pipeline.git
   cd deftunes-data-pipeline
   ```

2. Set up the development environment:
   ```bash
   pip install -r requirements.txt
   pre-commit install
   ```

3. Run tests to verify setup:
   ```bash
   pytest
   ```

## Code Style and Guidelines

- Follow PEP 8 style guidelines for Python code
- Use Black for code formatting
- Include docstrings for all modules, classes, and functions
- Write clear, descriptive commit messages
- Keep code modular and maintainable

## License

By contributing, you agree that your contributions will be licensed under the project's MIT License. 