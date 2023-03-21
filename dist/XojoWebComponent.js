"use strict";
var Example;
(function (Example) {
    class XojoWebComponent extends XojoWeb.XojoVisualControl {
        constructor(id, events) {
            super(id, events);
            this.mTextArea = document.createElement("xojo-textarea");
            const el = this.DOMElement("");
            if (!el) {
                return;
            }
            el.appendChild(this.mTextArea);
            this.mTextArea.addEventListener('change', (ev) => {
                const newValue = ev.detail.text;
                const data = new XojoWeb.JSONItem();
                data.set('text', newValue);
                this.triggerServerEvent('change', data, true);
            });
        }
        updateControl(data) {
            super.updateControl(data);
            const js = JSON.parse(data);
            this.mTextArea.setAttribute('limit', js.limit);
            this.mTextArea.setAttribute('text', js.text);
        }
        render() {
            super.render();
            const el = this.DOMElement("");
            if (!el) {
                return;
            }
            this.setAttributes(null);
            this.applyUserStyle(null);
            this.applyTooltip(el);
        }
    }
    Example.XojoWebComponent = XojoWebComponent;
})(Example || (Example = {}));
