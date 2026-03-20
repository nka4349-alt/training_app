module ProgressHelper
  def max_weight_line_chart(points, width: 720, height: 240)
    return content_tag(:p, "データが不足しています。", style: "font-size:12px; color:#667085;") if points.blank?

    labels = points.map { |label, _value| label.respond_to?(:strftime) ? label.strftime("%m/%d") : label.to_s }
    values = points.map { |_label, value| value.to_f.round(1) }

    min_value = values.min
    max_value = values.max
    pad = [((max_value - min_value).abs * 0.15), 1].max
    display_min = [0, min_value - pad].max
    display_max = max_value + pad
    display_range = [display_max - display_min, 1].max

    padding_left = 36.0
    padding_right = 16.0
    padding_top = 20.0
    padding_bottom = 30.0
    inner_width = width - padding_left - padding_right
    inner_height = height - padding_top - padding_bottom

    coordinates = values.each_with_index.map do |value, index|
      x =
        if values.size == 1
          padding_left + inner_width / 2.0
        else
          padding_left + (index * inner_width.to_f / (values.size - 1))
        end

      y = padding_top + inner_height - ((value - display_min) / display_range.to_f * inner_height)
      [x.round(2), y.round(2)]
    end

    line_points = coordinates.map { |x, y| "#{x},#{y}" }.join(" ")

    guides = [0.0, 0.33, 0.66, 1.0].map do |ratio|
      value = display_max - (display_range * ratio)
      y = padding_top + (inner_height * ratio)
      [value.round(1), y.round(2)]
    end

    content_tag(:svg, width: width, height: height, viewBox: "0 0 #{width} #{height}", style: "width:100%; height:auto; display:block;") do
      fragments = []

      guides.each do |value, y|
        fragments << tag.line(
          x1: padding_left,
          y1: y,
          x2: width - padding_right,
          y2: y,
          stroke: "#e5e7eb",
          "stroke-width": 1
        )

        fragments << content_tag(
          :text,
          value,
          x: 0,
          y: y + 4,
          style: "font-size:11px; fill:#667085;"
        )
      end

      fragments << tag.polyline(
        points: line_points,
        fill: "none",
        stroke: "#0ea5e9",
        "stroke-width": 3,
        "stroke-linecap": "round",
        "stroke-linejoin": "round"
      )

      coordinates.each_with_index do |(x, y), index|
        fragments << tag.circle(cx: x, cy: y, r: 4, fill: "#0ea5e9")

        fragments << content_tag(
          :text,
          labels[index],
          x: x,
          y: height - 8,
          "text-anchor": "middle",
          style: "font-size:11px; fill:#475467;"
        )

        fragments << content_tag(
          :text,
          values[index],
          x: x,
          y: y - 10,
          "text-anchor": "middle",
          style: "font-size:11px; fill:#0f172a; font-weight:600;"
        )
      end

      safe_join(fragments)
    end
  end

  def session_exercise_summary(workout_exercise, unit_label)
    done_sets = workout_exercise.set_entries.select(&:done?).sort_by(&:set_no)
    return "" if done_sets.empty?

    grouped = done_sets.group_by { |set_entry| [set_entry.weight.to_f.round(1), set_entry.reps.to_i] }

    grouped.map do |(weight, reps), entries|
      "#{weight}#{unit_label} × #{reps}回 × #{entries.size}set"
    end.join(" / ")
  end
end
