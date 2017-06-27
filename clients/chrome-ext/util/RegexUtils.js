if (!String.prototype.unescapeHtmlChars) {
    String.prototype.unescapeHtmlChars = function() {
        var value = this;

        value = value.replace(/&amp;/g, "&");
        value = value.replace(/&quot;/g, "\"");
        value = value.replace(/&apos;/g, "'");
        value = value.replace(/&nbsp;/g, " ");
        value = value.replace(/&gt;/g, ">");
        value = value.replace(/&lt;/g, "<");
        value = value.replace(/&rlm;/g, "");

        value = value.replace(/&#(\d+);/g, function(match, number) {
            return String.fromCharCode(parseInt(number, 10));
        });

        value = value.replace(/&#x([0-9a-fA-F]+);/g, function(match, hex) {
            return String.fromCharCode(parseInt(hex, 16));
        });
        return value;
    };
}


RegexUtis = {
    findValueByRegex : function findValueByRegex(serviceKey, label, regex, index, data, must) {
        var value = this.findMultiValuesByRegex(serviceKey, label, regex, [ index ], data, must)[0];
        return RegexUtis.cleanAndPretty(value);
    },

    findMultiValuesByRegex : function findMultiValuesByRegex(serviceKey, label, regex, indices, data) {
        var rawValues = data.match(regex);

        var values = [];

        if (!rawValues) {
            return values;
        }

        for (var i = 0; i < indices.length; i++) {
            values[values.length] = rawValues[indices[i]];
        }


        return values;
    },

    findAllOccurrencesByRegex : function findAllOccurrencesByRegex(serviceKey, label, regex, index, data, processor) {
        var rawValues = data.match(new RegExp(regex, 'g'));

        var values = [];
        if (!rawValues) {

            return values;
        }

        for (var i = 0; i < rawValues.length; i++) {
            var valueToProcess = ('' + rawValues[i]).match(regex)[index];

            if (processor)
                values[values.length] = processor(valueToProcess);
            else
                values[values.length] = valueToProcess;
        }

        return values;
    },

    clean: function (value) {
        if (value) {
            value = value.replace(/<[^>]*>/g, '');
        }

        return value;
    },

    prettify: function (value) {
        if (value) {
            value = value.trim();
            value = value.replace(/\s+/g, ' ');
            value = value.unescapeHtmlChars();
        }
        return value;
    },

    cleanAndPretty: function(value) {
        return RegexUtis.prettify(RegexUtis.clean(value));
    },

    findValueByRegex_CleanAndPretty : function findValueByRegex_CleanAndPretty(serviceKey, label, regex, index, data, must) {
        var value = RegexUtis.findValueByRegex(serviceKey, label, regex, index, data, must);

        return RegexUtis.cleanAndPretty(value);
    },

    findValueByRegex_Pretty : function findValueByRegex_Pretty(serviceKey, label, regex, index, data, must) {
        var value = RegexUtis.findValueByRegex(serviceKey, label, regex, index, data, must);
        return RegexUtis.prettify(value);
    }
};
