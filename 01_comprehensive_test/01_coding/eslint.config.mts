import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.recommended,
  {
    rules: {
      // 1. [Variables & Scope]
      // Allow unused variables only if they are prefixed with an underscore (e.g., _req, _res) to demonstrate an understanding of interface design
      "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
      // Disallow the use of 'var', enforcing 'let' or 'const' instead
      "no-var": "error",
      
      // 2. [Type Safety]
      // Highly recommended! Disallow the use of 'any' to showcase your mastery of the TypeScript type system
      "@typescript-eslint/no-explicit-any": "warn", 
      // Recommend explicitly defining return types for functions so reviewers immediately understand the function's purpose (a big plus during assessments)
      "@typescript-eslint/explicit-function-return-type": "warn",

      // 3. [Error Prevention & Code Quality]
      // Enforce the use of '===' and '!==' to prevent bizarre bugs caused by JavaScript's implicit type coercion
      "eqeqeq": ["error", "always"],
      // Standard 'console.log' should not be left in production API logic (a logger package is recommended); set to 'warn' as a personal reminder
      "no-console": ["warn", { allow: ["warn", "error", "info"] }],
      // Prevent redeclaring variables with the same name
      "no-redeclare": "error"
    }
  }
);