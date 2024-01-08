# LWC Components
GameForce relies on LWC components as a main tool for UI. All new UI related features have to be developed using LWC components, unless there is a LWC limitation preventing feature development. While GameForce doesn't rely on any specific frameworks and follows standard guidelines for LWC development, there are two project specific implementations (with a third one coming in Milestone 3) that are worth mentioning

## Displaying error messages using illustration components
GameForce non-modal LWC components rely on [Illustrations](https://www.lightningdesignsystem.com/components/illustration/#site-main-content) to better represent issues or warnings to user, instead of firing a toast message. This is especially important when multiple components are displayed on the same page and might fail due to limited access etc. In this scenario, Illustration components would provide more time and better guidance for end user, while toast messages might overwhelm the user. Toast messages are used in GameForce only as a result of an execution of a background operation (which is uncommon for the solution)

| Component | Description |
|-----------|------------ |
| svgNoData | Used to show that no data was returned (no issue) |
| svgError | Used to show critical errors to user (exceptions or access issues) |
| svgMountain | Used to encourage user and to show that there is "no progress yet" |
| svgWidgetsStub | Temporary Illustration component used for Milestone 2 as a placeholder |

## Confetti effect
The "confetti effect" is used in GameForce to encourage users whenever they unlock new achievement. Confetti effect is implemented by adding confetti lwc component as a child of a component that needs to trigger an event. While confetti LWC component is reusable, it is not meant to be used anywhere else other then in gameForceNotification component