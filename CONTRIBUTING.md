# Contributing to HEIC Converter

Thank you for your interest in contributing to the HEIC Converter project! This document provides guidelines for contributing to the project.

## Code of Conduct
Please be respectful and constructive in all interactions. This project aims to be welcoming to contributors of all skill levels.

## How to Contribute

### Reporting Issues
- Check existing issues before creating a new one
- Provide clear reproduction steps
- Include system information (Windows version, PowerShell version, ImageMagick version)
- Include error messages and screenshots if applicable

### Suggesting Features
- Open an issue with the "enhancement" label
- Describe the problem the feature would solve
- Provide mockups or examples if helpful

### Code Contributions

#### Before Starting
1. Fork the repository
2. Create a feature branch from `main`
3. Set up your development environment (see DEVELOPMENT.md)

#### Making Changes
1. Follow the existing code style
2. Test your changes thoroughly on Windows systems
3. Update documentation if needed
4. Keep commits focused and atomic

#### Code Standards
- Use clear, descriptive variable names
- Add comments for complex logic
- Follow PowerShell best practices
- Ensure GUI elements are properly sized and positioned
- Handle errors gracefully with user-friendly messages

#### Testing Checklist
- [ ] Application starts without errors
- [ ] Folder selection dialog works
- [ ] All format options (jpg, png, bmp, gif) work correctly
- [ ] Progress bar updates during conversion
- [ ] Error handling works for common scenarios
- [ ] UI remains responsive during operations
- [ ] Built executable works as expected

#### Submitting Changes
1. Push your feature branch to your fork
2. Create a Pull Request against the `main` branch
3. Fill out the PR template completely
4. Be prepared to address review feedback

## Development Process

### Branch Naming
- `feature/description` for new features
- `fix/description` for bug fixes
- `docs/description` for documentation changes

### Commit Messages
Use clear, descriptive commit messages:
- `feat: add support for webp format`
- `fix: handle empty folder selection gracefully`
- `docs: update installation instructions`

### Pull Request Guidelines
- Include a clear description of changes
- Reference related issues
- Include screenshots for UI changes
- Ensure all checks pass

## License Compliance
By contributing, you agree that your contributions will be licensed under the same license as the project. Please note the redistribution restrictions in the LICENSE file.

## Questions?
If you have questions about contributing, please open an issue with the "question" label.