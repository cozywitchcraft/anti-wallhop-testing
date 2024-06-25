local function floatToString(value: number)
	return string.gsub(string.format(`%.3f`, value), "%.?0+$", "")
end

return {
	floatToString = floatToString,
}
