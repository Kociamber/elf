defmodule ElfWeb.CodeLive do
  use Phoenix.LiveView
  # TODO: move html to a template

  def mount(_session, socket) do
    assigns =
      socket
      |> assign(:unformatted_code, nil)
      |> assign(:formatted_code, nil)
      |> assign(:credo_issues, nil)

    {:ok, assigns}
  end

  def render(assigns) do

    # ~L"""
    # <section class="row codearea">
    #   <section class="column">
    #     <h4>Your shit goes here</h3>
    #     <form phx-change="write_code">
    #       <textarea name="code_area" rows="250" cols="250" class="form-control" autofocus="autofocus"><%= @unformatted_code %></textarea>
    #       <button phx-click="submit" value="<%= @formatted_code %>">Credo shit</button>
    #     </form>
    #   </section>
    #   <section class="column">
    #     <h4>Formatted shit</h3>
    #     <textarea rows="250" cols=250" disabled="disabled"><%= @formatted_code %></textarea>
    #     <%= if(@credo_issues) do %>
    #       <%= for issue <- @credo_issues do %>
    #         <%= for {key, value} <- issue do %>
    #           <%= if(key != "filename") do %>
    #             <b><%= key %></b>: <%= value %><br>
    #             <% end %>
    #         <% end %>
    #       <% end %>
    #     <% end %>
    #   </section>
    # </section>
    # """
    ~L"""
    <div class="row">
      <div class="column">
        <h4>Your shit goes here</h4>
        <form phx-change="write_code">
          <textarea name="code_area" rows="250" cols="250" class="form-control" autofocus="autofocus"><%= @unformatted_code %></textarea>
          <button class="button button-outline" phx-click="submit" value="<%= @formatted_code %>">Credo shit</button>
        </form>
      </div>
      <div class="column">
        <h4>Formatted shit</h4>
        <pre><code><%= @formatted_code %></code></pre>
        <%= if(@credo_issues) do %>
          <pre><code><%= for issue <- @credo_issues do %><%= for {key, value} <- issue do %><%= if(key != "filename") do %><b><%= key %></b>: <%= value %></br><% end %><% end %><% end %></code></pre>
        <% end %>
      </div>
    </div>
    """
  end

  def handle_event("write_code", %{"code_area" => code_to_format}, socket) do
    formatted_code = Code.format_string!(code_to_format)
    {:noreply, assign(socket, :formatted_code, formatted_code)}
  rescue
    error ->
      {:noreply, assign(socket, :formatted_code, Map.get(error, :description))}
  end

  # ignore submitting empty code
  def handle_event("submit", "", socket), do: {:noreply, socket}

  def handle_event("submit", formatted_code, socket) do
    credo_issues =
      formatted_code
      |> run_credo()
      |> Map.get("issues")
      |> IO.inspect(label: "credo submit~~~")

    {:noreply, assign(socket, :credo_issues, credo_issues)}
  end

  # TODO: add more options, ie: run credo as for .exs, --all
  defp run_credo(code) do
    file_name = "#{UUID.uuid4()}.ex"
    :ok = File.write(file_name, code)

    {:ok, credo_issues} =
      'mix credo --all --format=json #{file_name}'
      |> :os.cmd()
      |> to_string()
      # |> String.replace("\n", "")
      |> IO.inspect(label: "credo json~~~")
      |> Jason.decode()

    :ok = File.rm(file_name)
    credo_issues
  end
end
