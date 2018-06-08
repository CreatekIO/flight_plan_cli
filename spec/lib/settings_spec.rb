require 'spec_helper'

RSpec.describe FlightPlanCli::Settings do
  include FakeFS::SpecHelpers

  def write_config(path, config = {})
    file = Pathname.new(path)
    file.dirname.mkpath

    serialized = config.is_a?(String) ? config : YAML.dump(config)

    file.write(file, serialized)
  end

  def in_directory(path)
    FileUtils.mkpath(path)
    Dir.chdir(path) { yield }
  end

  def quit_with_message(message)
    message = "#{message}\n" if message.is_a? String
    raise_error(SystemExit).and output(message).to_stderr
  end

  let(:home_dir) { '/Users/fpcli' }
  let(:project_dir) { "#{home_dir}/projects/my_project" }

  subject { described_class.new }

  before do
    allow(Dir).to receive(:home).and_return(home_dir)
  end

  describe 'base config' do
    let(:filename) { described_class::CONFIG_YAML_PATH }

    it 'reads file if in the current directory' do
      config = { 'flight_plan_api_key' => 'in current directory' }

      in_directory(project_dir) do
        write_config(filename, config)

        aggregate_failures do
          expect(subject.base_config_file.to_path).to eq(
            "#{project_dir}/#{filename}"
          )
          expect(subject.base_config).to eq(config)
        end
      end
    end

    it 'finds file if in the directory above' do
      directory_above = File.dirname(project_dir)
      config = { 'flight_plan_api_key' => 'in directory above' }

      in_directory(directory_above) do
        write_config(filename, config)
      end

      in_directory(project_dir) do
        aggregate_failures do
          expect(subject.base_config_file.to_path).to eq(
            "#{directory_above}/#{filename}"
          )
          expect(subject.base_config).to eq(config)
        end
      end
    end

    it 'finds file if in user\'s home directory' do
      config = { 'flight_plan_api_key' => 'in home directory' }

      in_directory(Dir.home) do
        write_config(filename, config)
      end

      in_directory(project_dir) do
        aggregate_failures do
          expect(subject.base_config_file.to_path).to eq(
            "#{home_dir}/#{filename}"
          )
          expect(subject.base_config).to eq(config)
        end
      end
    end

    it 'exits with error if no file found anywhere' do
      aggregate_failures do
        expect {
          subject.base_config_file
        }.to quit_with_message("#{filename} not found".red.bold)

        expect {
          subject.base_config
        }.to quit_with_message("#{filename} not found".red.bold)
      end
    end

    it 'exits with error if file exists above home directory' do
      write_config("/#{filename}")

      in_directory(project_dir) do
        aggregate_failures do
          expect {
            subject.base_config_file
          }.to quit_with_message("#{filename} not found".red.bold)

          expect {
            subject.base_config
          }.to quit_with_message("#{filename} not found".red.bold)
        end
      end
    end

    context 'with invalid YAML' do
      describe '#base_config' do
        it 'exits with error' do
          in_directory(project_dir) do
            write_config(filename, "---\nthis_is: 'invalid")

            expect {
              subject.base_config
            }.to quit_with_message(%r{Error parsing `#{project_dir}/#{filename}`:})
          end
        end
      end
    end
  end

  describe 'user config' do
    let(:filename) { described_class::USER_YAML_PATH }

    it 'returns file if in the current directory' do
      config = { 'flight_plan_api_secret' => 'in current directory' }

      in_directory(project_dir) do
        write_config(filename, config)

        aggregate_failures do
          expect(subject.user_config_file.to_path).to eq(
            "#{project_dir}/#{filename}"
          )
          expect(subject.user_config).to eq(config)
        end
      end
    end

    it 'finds file if in the directory above' do
      directory_above = File.dirname(project_dir)
      config = { 'flight_plan_api_secret' => 'in directory above' }

      in_directory(directory_above) do
        write_config(filename, config)
      end

      in_directory(project_dir) do
        aggregate_failures do
          expect(subject.user_config_file.to_path).to eq(
            "#{directory_above}/#{filename}"
          )
          expect(subject.user_config).to eq(config)
        end
      end
    end

    it 'finds file if in user\'s home directory' do
      config = { 'flight_plan_api_secret' => 'in home directory' }

      in_directory(Dir.home) do
        write_config(filename, config)
      end

      in_directory(project_dir) do
        aggregate_failures do
          expect(subject.user_config_file.to_path).to eq(
            "#{home_dir}/#{filename}"
          )
          expect(subject.user_config).to eq(config)
        end
      end
    end

    describe '#user_config_file' do
      it 'returns nil if no file found anywhere' do
        expect(subject.user_config_file).to be_nil
      end

      it 'returns nil if file exists above home directory' do
        write_config("/#{filename}")

        in_directory(project_dir) do
          expect(subject.user_config_file).to be_nil
        end
      end
    end

    describe '#user_config' do
      it 'returns empty hash if no file found anywhere' do
        expect(subject.user_config).to eq({})
      end

      it 'returns empty hash if file exists above home directory' do
        write_config("/#{filename}")

        in_directory(project_dir) do
          expect(subject.user_config).to eq({})
        end
      end

      context 'with invalid YAML' do
        it 'exits with error' do
          in_directory(project_dir) do
            write_config(filename, "---\nthis_is: 'invalid")

            expect {
              subject.user_config
            }.to quit_with_message(%r{Error parsing `#{project_dir}/#{filename}`:})
          end
        end
      end
    end
  end
end
