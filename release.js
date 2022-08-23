// npx semantic-release -e ./release.js

module.exports = {
  dryRun: false,
  plugins: [
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    [ "@semantic-release/npm", {
        npmPublish: false } ],
    [ "@semantic-release/git", {
        assets: [
          "VERSION",
          "openapi.yaml",
          "CHANGELOG.md",
          "package.json" ],
        message: "Bumped new version ${nextRelease.version} [skip ci]" }
    ],
    // BuildKit is not able to push back multi arch builds via buildx build --load
    // We cannot use the plugin for pushing multi arch
    /* [ "@semantic-release-plus/docker", {
        skipLogin: true,
        name: "name/repo:semantic-release" }
    ], */
    [ "@semantic-release/github", {
        assets: [
          { path: "openapi.yaml", label: "DNS3L OpenAPI (Swagger) Specification" } ],
        addReleases: "top" }
    ]
  ]
};
