// npx semantic-release -e ./release.js

module.exports = {
  dryRun: false,
  plugins: [
    "@semantic-release/release-notes-generator",
    [ "@semantic-release/npm", {
        npmPublish: false } ],
    [ "@semantic-release/github", {
        assets: [
          { path: "openapi.yaml", label: "DNS3L OpenAPI (Swagger) Specification" } ],
        addReleases: "top" }
    ]
  ]
};
