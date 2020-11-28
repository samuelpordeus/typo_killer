defmodule TypoKiller.Case do
  use ExUnit.CaseTemplate

  using do
    quote do
      @file_with_typo "./test/fixtures/file_with_typo.txt"
      @file_with_typo_output File.read!("./test/fixtures/file_with_typo_output.txt")
      @file_with_typo_output_using_options File.read!(
                                             "./test/fixtures/file_with_typo_output_using_options.txt"
                                           )
      import ExUnit.CaptureIO
    end
  end
end
