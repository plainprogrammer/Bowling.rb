# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands
- Run all tests: `bundle exec rspec`
- Run a single test: `bundle exec rspec spec/path/to_spec.rb:LINE_NUMBER`
- Run tests with a specific tag: `bundle exec rspec --tag focus`
- Install dependencies: `bundle install`

## Code Style Guidelines
- Use frozen_string_literal comment at the top of Ruby files
- Follow standard Ruby naming conventions:
  - snake_case for methods and variables
  - CamelCase for classes and modules
- Prefer double quotes for strings
- Use two-space indentation
- Keep methods small and focused on a single responsibility
- Write descriptive RSpec tests with clear contexts and expectations
- Handle errors with appropriate rescue blocks
- Use proper Ruby idioms (e.g., blocks, enumerable methods)
- Keep line length under 100 characters
- Include docstrings for public methods