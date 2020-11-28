%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/"],
        excluded: ["test/"]
      },
      strict: true,
      color: true
    }
  ]
}
