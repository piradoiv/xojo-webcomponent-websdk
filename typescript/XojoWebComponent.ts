namespace Example {
    export class XojoWebComponent extends XojoWeb.XojoVisualControl {
        private mTextArea = document.createElement("xojo-textarea");

        constructor(id: string, events: string[]) {
            super(id, events);
            const el = this.DOMElement("");
            if (!el) {
                return;
            }

            el.appendChild(this.mTextArea);

            this.mTextArea.addEventListener('change', (ev) => {
                // @ts-ignore
                const newValue = ev.detail.text;
                const data = new XojoWeb.JSONItem();
                data.set('text', newValue);
                this.triggerServerEvent('change', data, true);
            })
        }

        updateControl(data: string) {
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
}