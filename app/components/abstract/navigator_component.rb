# frozen_string_literal: true

class Abstract::NavigatorComponent < ApplicationComponent
  def classes
    classes_array = [ "cursor-pointer" ]

    classes_array.push(*filled_classes) if style == :filled
    classes_array.push(*outlined_classes) if style == :outlined
    classes_array.push(*text_classes) if style == :text
    classes_array.push(*inline_classes) if style == :inline

    classes_array.join(" ")
  end

  def filled_classes
    classes_array = [ "w-full", "sm:w-auto", "text-center", "rounded-md", "px-3.5", "py-2.5", "", "inline-block", "font-medium" ]

    classes_array.push("bg-white", "hover:bg-gray-100", "text-yin") if level == :primary
    classes_array.push("bg-gray-100", "hover:bg-gray-100", "text-yin-900") if level == :secondary

    classes_array
  end

  def outlined_classes
    classes_array = [ "w-full", "sm:w-auto", "text-center", "rounded-md", "px-3.5", "py-2.5", "inline-block", "font-medium" ]

    classes_array.push("border-1", "border-white", "hover:bg-yin-800", "text-white") if level == :primary
    classes_array.push("border-1", "hover:bg-yin-800", "text-yin-400") if level == :secondary


    classes_array
  end

  def text_classes
    classes_array = [ "inline-flex", "p-0", "underline", "hover:no-underline" ]

    classes_array.push(external? ? "decoration-dashed" : "underline")

    classes_array.push("text-white", "hover:text-gray-200") if level == :primary
    classes_array.push("text-gray-400", "hover:text-gray-200") if level == :secondary

    classes_array
  end

  def inline_classes
    classes_array = [ "inline-block", "p-0" ]

    classes_array.push("text-white", "hover:text-gray-200") if level == :primary
    classes_array.push("text-gray-400", "hover:text-gray-200") if level == :secondary

    classes_array
  end

  def external?
    # this is smelly but gotta fix
    defined?(external) && external
  end
end
