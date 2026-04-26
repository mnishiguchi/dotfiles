-- Custom filetype detection.
--
-- Keep this file focused on filetypes that are useful for my work.
-- Prefer Neovim's built-in detection unless a filetype is missing or ambiguous.

vim.filetype.add({
  extension = {
    -- Livebook
    livemd = "markdown",

    -- Rails / ERB
    erb = "eruby",

    -- Go templates
    gotmpl = "gotmpl",

    -- MDX
    mdx = "markdown.mdx",

    -- Ruby
    jbuilder = "ruby",
    rake = "ruby",
  },

  filename = {
    -- Ruby
    ["Gemfile"] = "ruby",
    ["Rakefile"] = "ruby",
    ["Vagrantfile"] = "ruby",
    ["Thorfile"] = "ruby",
    ["Guardfile"] = "ruby",
    ["config.ru"] = "ruby",

    -- YAML variants used by common LSP configs
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    [".gitlab-ci.yml"] = "yaml.gitlab",
  },

  pattern = {
    -- Helm values files
    [".*/values%.ya?ml"] = "yaml.helm-values",
    [".*/values%..*%.ya?ml"] = "yaml.helm-values",
  },
})
