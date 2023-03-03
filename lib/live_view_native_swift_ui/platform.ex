defmodule LiveViewNativeSwiftUi.Platform do
  import LiveViewNativePlatform.Utils,
    only: [check_dependency!: 1, check_platform!: 2, run_command!: 3]

  defstruct [
    :app_name,
    :bundle_name,
    :custom_modifiers,
    :project_path,
    default_simulator_device: "iPhone 13",
    default_simulator_os: "iOS",
    default_simulator_os_version: "16-0",
    xcode_path: "/Applications/Xcode.app"
  ]

  defimpl LiveViewNativePlatform do
    require Logger

    alias LiveViewNativeSwiftUi.Modifiers

    def context(struct) do
      %LiveViewNativePlatform.Context{
        custom_modifiers: struct.custom_modifiers || [],
        modifiers: %LiveViewNativeSwiftUi.Modifiers{stack: []},
        platform_id: :ios,
        platform_modifiers: [
          font_weight: Modifiers.FontWeight,
          frame: Modifiers.Frame,
          list_row_insets: Modifiers.ListRowInsets,
          list_row_separator: Modifiers.ListRowSeparator,
          navigation_title: Modifiers.NavigationTitle,
          padding: Modifiers.Padding,
          tint: Modifiers.Tint,

          # grid
          grid_cell_anchor: Modifiers.GridCellAnchor,
          grid_cell_columns: Modifiers.GridCellColumns,
          grid_cell_unsized_axes: Modifiers.GridCellUnsizedAxes,
          grid_column_alignment: Modifiers.GridColumnAlignment,

          rename_action: Modifiers.RenameAction
        ],
        template_engine: LiveViewNative.Engine,
        template_namespace: SwiftUi
      }
    end

    def start_simulator(struct, opts \\ []) do
      %{
        app_name: app_name,
        bundle_name: bundle_name,
        default_simulator_device: default_simulator_device,
        default_simulator_os: default_simulator_os,
        default_simulator_os_version: default_simulator_os_version,
        project_path: project_path,
        xcode_path: xcode_path
      } = struct

      # Raises if either `xcrun` or `xcodebuild` are missing from the current system PATH.
      # These are requirements to run the Simulator
      check_dependency!("xcrun")
      check_dependency!("xcodebuild")

      # Raises if `LiveViewNativeSwiftUi.Platform` isn't configured to support Simulator.
      check_platform!(struct, %{
        app_name: [:must_be_string],
        bundle_name: [:must_be_string],
        project_path: [:must_be_string, :must_point_to_directory]
      })

      # Get Simulator options from arguments, falling back to the `LiveViewNativeSwiftUi.Platform`
      # configuration or defaults.
      simulator_device = Keyword.get(opts, :device, default_simulator_device)
      simulator_os = Keyword.get(opts, :os, default_simulator_os)
      simulator_os_version = Keyword.get(opts, :os_version, default_simulator_os_version)

      # Get the Simulator device information using the result of `xcrun simctl list --json devices available`
      Logger.info("Checking for available devices.")

      %{"devices" => devices} =
        run_command!("xcrun", ["simctl", "list", "--json", "devices", "available"], format: :json)

      devices_for_os =
        Map.get(
          devices,
          "com.apple.CoreSimulator.SimRuntime.#{simulator_os}-#{simulator_os_version}",
          []
        )

      device_info = Enum.find(devices_for_os, &(&1["name"] == simulator_device))

      # Run the app in the specified Simulator if it exists.
      case device_info do
        %{"udid" => udid} ->
          # Setup a build path
          live_view_native_priv_dir = :code.priv_dir(:live_view_native)
          platform_builds_path = Path.join(live_view_native_priv_dir, "platform_builds")
          File.mkdir(platform_builds_path)
          build_path = Path.join(platform_builds_path, "#{app_name}.#{udid}")
          File.mkdir(build_path)

          # Build a project bundle for the Simulator
          Logger.info(
            "Building #{app_name}.app for #{simulator_device} (#{simulator_os} #{simulator_os_version})..."
          )

          run_command!(
            "xcrun",
            [
              "xcodebuild",
              "-scheme",
              app_name,
              "-project",
              Path.expand(project_path),
              "-configuration",
              "Debug",
              "-destination",
              "id=#{udid}",
              "-derivedDataPath",
              build_path
            ],
            []
          )

          # Run the Simulator
          Logger.info(
            "Running simulator for #{simulator_device} (#{simulator_os} #{simulator_os_version})..."
          )

          simulator_path =
            Path.join(
              xcode_path,
              "Contents/Developer/Applications/Simulator.app/Contents/MacOS/Simulator"
            )

          run_command!(simulator_path, ["-CurrentDeviceUDID", udid], [])

          # Install the project bundle in the Simulator and launch it
          Logger.info("Running #{app_name}.app in simulator...")

          run_command!(
            "xcrun",
            [
              "simctl",
              "install",
              udid,
              "#{build_path}/Build/Products/Debug-iphonesimulator/#{app_name}.app"
            ],
            []
          )

          run_command!("xcrun", ["simctl", "launch", udid, bundle_name], [])

        device_info ->
          raise "Missing or invalid Simulator device: #{device_info}"
      end
    end
  end
end
