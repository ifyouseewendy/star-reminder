import React, { Component } from "react";
import PropTypes from "prop-types";
import {
  Button,
  CalloutCard,
  Card,
  DisplayText,
  FormLayout,
  Layout,
  Select,
  Stack,
  TextField,
} from "@shopify/polaris";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      digestCount: props.digestCount,
      deliveryAt: props.deliveryAt,
      delivery: {
        frequency: "every week",
        hour: "8",
        meridiem: "am",
      },
    };
  }

  valueChanged() {
    return (
      this.props.digestCount !== this.state.digestCount ||
      this.props.deliveryAt !== this.state.deliveryAt
    );
  }

  renderIndex() {
    return (
      <Layout>
        <Layout.Section>
          <DisplayText size="Large">{"> Github Star Reminder"}</DisplayText>
        </Layout.Section>
        <Layout.Section>
          <CalloutCard
            illustration="https://assets-cdn.github.com/images/modules/logos_page/Octocat.png"
            primaryAction={{
              content: "Login via Github",
              url: "/auth/github",
            }}
          >
            <p>Get a digest email of your Github stars every week.</p>
          </CalloutCard>
        </Layout.Section>
      </Layout>
    );
  }

  renderDashboard() {
    console.log(this.state);
    return (
      <Layout>
        <Layout.Section>
          <DisplayText size="Large">{"> Github Star Reminder"}</DisplayText>
        </Layout.Section>
        <Layout.Section>
          <Card sectioned>
            <FormLayout>
              <TextField
                label="Email"
                name="email"
                type="email"
                value={this.props.email}
                disabled
              />
              <TextField
                label="Github username"
                name="github-username"
                type="text"
                value={this.props.githubUserName}
                disabled
              />
              <Stack
                alignment="trailing"
                distribution="fill"
              >
                <TextField
                  label="Send email"
                  prefix="at"
                  type="number"
                  min="1"
                  max="12"
                  value={this.state.delivery.hour}
                  onChange={v =>
                    this.setState({
                      delivery: {
                        ...this.state.delivery,
                        hour: v,
                      },
                    })
                  }
                  connectedRight={
                    <Select
                      label="meridiem"
                      labelHidden
                      options={["am", "pm"]}
                      value={this.state.delivery.meridiem}
                      onChange={selected =>
                        this.setState({
                          delivery: {
                            ...this.state.delivery,
                            meridiem: selected,
                          },
                        })
                      }
                    />
                  }
                />
                <Select
                  options={["every week", "every day"]}
                  value={this.state.delivery.frequency}
                  onChange={selected =>
                    this.setState({
                      delivery: {
                        ...this.state.delivery,
                        frequency: selected,
                      },
                    })
                  }
                />
              </Stack>
              <TextField
                label="Digest count of each email"
                type="number"
                value={this.state.digestCount}
                min="0"
                onChange={v => this.setState({ digestCount: Number(v) })}
              />
              <Button primary url="#" disabled={!this.valueChanged()} submit>
                Save
              </Button>
            </FormLayout>
          </Card>
        </Layout.Section>
      </Layout>
    );
  }

  render() {
    if (this.props.email) {
      return this.renderDashboard();
    }
    return this.renderIndex();
  }
}

App.propTypes = {
  email: PropTypes.string.isRequired,
  githubUserName: PropTypes.string.isRequired,
  deliveryAt: PropTypes.string.isRequired,
  digestCount: PropTypes.number.isRequired,
};

export default App;
